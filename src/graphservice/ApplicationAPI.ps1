# Copyright 2018, Adam Edwards
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. (import-script ../cmdlets/Invoke-GraphRequest)
. (import-script ../common/GraphApplicationCertificate)
. (import-script ../common/ScopeHelper)

enum AppTenancy {
    Auto
    SingleTenant
    AnyTenant
}

ScriptClass ApplicationAPI {
    static {
        const DefaultApplicationApiVersion beta
    }

    $version = $null
    $connection = $null

    function __initialize($connection, $version) {
        $this.connection = $connection
        $this.version = if ( $version ) {
            $version
        } else {
            $this.scriptclass.DefaultApplicationApiVersion
        }
    }

    function CreateApp($appObject) {
         Invoke-GraphRequest applications -method POST -body $appObject -version $this.version -connection $this.connection
    }

    function AddKeyCredentials($appObject, $appCertificate) {
        # This should be additive, but methods to add to the collection
        # don't seem to work
        $keyCredentials = @()

        $encodedCertificate = $appCertificate |=> GetEncodedPublicCertificate

        $keyCredentials += [PSCustomObject] @{
            type = 'AsymmetricX509Cert'
            usage = 'Verify'
            key = $encodedCertificate
        }

        $appPatch = (
            [PSCustomObject] @{
                keyCredentials = $keyCredentials
            }
        ) | convertto-json -depth 20

        Invoke-GraphRequest "applications/$($appObject.Id)" -method PATCH -Body $appPatch -version $this.version -connection $this.connection
    }

    function SetKeyCredentials($appId, $keyCredentials) {
        $keyCredentialPatch = [PSCustomObject] @{
            keyCredentials = $keyCredentials
        }

        Invoke-GraphRequest "applications/$appId" -method PATCH -Body $keyCredentialPatch -version $this.version -connection $this.connection | out-null
    }

    function RegisterApplication($appId, $isExternal) {
        if ( ! $isExternal ) {
            $app = invoke-graphrequest /applications -method GET -odatafilter "appId eq '$appId'" -version $this.version -connection $this.connection -erroraction stop

            if ( ! $App ) {
                throw "An application with AppId '$AppId' could not be found in this tenant."
            }
        }

        $appSP = GetAppServicePrincipal $appId

        if ( $appSP -and $appSP | gm id ) {
            throw "Application is already registered with service principal id = '$($appSP.id)'"
        }

        NewAppServicePrincipal $appId | out-null
        $app
    }

    function NewAppServicePrincipal($appId) {
        invoke-graphrequest /servicePrincipals -method POST -body @{appId=$appId} -Version $this.version -connection $this.connection -erroraction stop
    }

    function GetAppServicePrincipal($appId, $errorAction = 'stop') {
        invoke-graphrequest /servicePrincipals -method GET -ODataFilter "appId eq '$appId'" -Version $this.version -connection $this.connection -erroraction $errorAction
    }

    function GetApplicationByAppId($appId, $errorAction = 'stop') {
        invoke-graphrequest /Applications -method GET -ODataFilter "appId eq '$appId'" -Version $this.version -connection $this.connection -erroraction $errorAction
    }

    function GetApplicationByObjectId($objectId, $errorAction = 'stop') {
        invoke-graphrequest "/Applications/$objectId" -method GET -Version $this.version -connection $this.connection -erroraction $errorAction
    }

    function RemoveApplicationByObjectId($objectId, $errorAction = 'stop') {
        invoke-graphrequest "/Applications/$objectId" -method DELETE -Version $this.version -connection $this.connection -erroraction $erroraction| out-null
    }

    function GetReducedPermissionsString($permissionsString, $permissionsToRemove) {
        $permissions = $permissionsString -split ' '

        $newPermissions = $permissions | where { $permissionsToRemove -notcontains $_ }

        $reducedPermissionsString = $newPermissions -join ' '

        if ( $permissionsString -ne $reducedPermissionsString ) {
            $reducedPermissionsString
        }
    }

    function SetConsent (
        $appObject,
        [string[]] $delegatedPermissions,
        [string[]] $appOnlyPermissions,
        $allPermissions,
        $consentForTenant,
        $userConsentRequired,
        $userIdToConsent
    ) {
        $consentUser = if ( $userIdToConsent ) {
            write-verbose "User '$userIdToConsent' specified for consent"
            $userIdToConsent
        } elseif ( ! $consentForTenant ) {
            write-verbose "No user was specified for consent, and consent for the entire tenant was not specified, so consent will be made for the user making this Graph API call"
            $userObjectId = ('GraphContext' |::> GetConnection).Identity.GetUserInformation().userObjectId
            if ( ! $userObjectId -and $userConsentRequired ) {
                throw "User consent required but no user was specified and user id of current user could not be obtained"
            }
            write-verbose "Attempting to grant consent to app '$($appObject.appId)' for current user '$userObjectId'"
            $userObjectId
        } else {
            write-verbose "User consent was not specified, and tenant consent was specified, will attempt to consent all app permissions for the tenant"
        }

        if ( $userConsentRequired -and ! $consentUser ) {
            write-verbose "No user was specified for consent, and user consent was required, so skipping consent completely"
            return
        }

        $grant = GetConsentGrantForApp $appObject $consentUser $DelegatedPermissions $AppOnlyPermissions $allPermissions

        Invoke-GraphRequest /oauth2PermissionGrants -method POST -body $grant -version $this.version -connection $this.connection | out-null
    }

    function GetConsentGrantForApp(
        $app,
        $consentUser,
        $scopes = @(),
        $roles = @(),
        $ConsentRequiredPermissions
    ) {
        $targetPermissions = if ( ! $ConsentRequiredPermissions ) {
            $scopes + $roles
        } else {
            $permissions = @()
            $graphResourceAccess = $app.requiredResourceAccess | where resourceAppid -eq 00000003-0000-0000-c000-000000000000

            $graphResourceAccess.resourceAccess | foreach {
                $permissionId = $_.id
                $permissionName = $::.ScopeHelper |=> GraphPermissionIdToName $permissionId
                $permissions += $permissionName
            }
            $permissions
        }

        __NewOauth2Grant $app.appId ($targetPermissions -join ' ') $consentUser
    }

    function __NewOauth2Grant($appId, [string] $permissionName, $consentUserId) {
        $appSP = GetAppServicePrincipal $appId

        if ( ! $appSP -or ! ($appSP | gm id -erroraction silentlycontinue) ) {
            throw "Application '$AppId' was not found"
        }

        $consentType = if ( $consentUserId ) {
            'Principal'
        } else {
            'AllPrincipals'
        }

        @{
            clientId = $appSP.id
            consentType = $consentType
            resourceId = $::.ScopeHelper |=> GetGraphServicePrincipalId
            principalId = $consentUserId
            scope = $permissionName
            startTime = (([DateTime]::UtcNow) - ([TimeSpan]::FromDays(1))).tostring('s')
            expiryTime = (([DateTime]::UtcNow) + ([TimeSpan]::FromDays(365))).tostring('s')
        }
    }
}
