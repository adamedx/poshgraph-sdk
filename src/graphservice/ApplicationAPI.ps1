# Copyright 2021, Adam Edwards
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

. (import-script ../cmdlets/Invoke-GraphApiRequest)
. (import-script ../common/GraphApplicationCertificate)
. (import-script ../common/ScopeHelper)

enum AppTenancy {
    Auto
    SingleTenant
    AnyTenant
}

ScriptClass ApplicationAPI {
    static {
        const DefaultApplicationApiVersion 'v1.0'
        $TenantToGraphServicePrincipal = @{}
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
         Invoke-GraphApiRequest /applications -method POST -body $appObject -version $this.version -connection $this.connection -ConsistencyLevel Session
    }

    function AddKeyCredentials($appObject, [object[]] $appCertificates, [bool] $preserveExisting, [bool] $isServicePrincipal) {
        if ( ! $appCertificates -and $preserveExisting ) {
            throw "No certificates were specified"
        }

        # This should be additive, but methods to add to the collection
        # don't seem to work
        $keyCredentials = @()

        if ( $preserveExisting -and ($appObject.keyCredentials | measure-object).count ) {
            $appObject.keyCredentials | foreach {
                $keyCredentials += $_
            }
        }

        foreach ( $appCertificate in $appCertificates ) {
            $encodedCertificate = if ( $appCertificate -is [System.Security.Cryptography.X509Certificates.X509Certificate2 ] ) {
                $::.CertificateHelper |=> GetEncodedPublicCertificateData $appCertificate
            } else {
                $appCertificate |=> GetEncodedPublicCertificate
            }

            $keyCredentials += [PSCustomObject] @{
                type = 'AsymmetricX509Cert'
                usage = 'Verify'
                key = $encodedCertificate
            }
        }

        $appPatch = (
            [PSCustomObject] @{
                keyCredentials = $keyCredentials
            }
        ) | convertto-json -depth 6

        $targetClass = if ( $isServicePrincipal ) {
            'servicePrincipals'
        } else {
            'applications'
        }

        Invoke-GraphApiRequest "/$targetClass/$($appObject.Id)" -method PATCH -Body $appPatch -version $this.version -connection $this.connection -ConsistencyLevel Session
    }

    function SetKeyCredentials($appId, $keyCredentials) {
        $keyCredentialPatch = [PSCustomObject] @{
            keyCredentials = $keyCredentials
        }

        Invoke-GraphApiRequest "/applications/$appId" -method PATCH -Body $keyCredentialPatch -version $this.version -connection $this.connection -ConsistencyLevel Session | out-null
    }

    function RegisterApplication($appId, $isExternal) {
        write-verbose "Attempting to register existing application '$appId', isExternalTenant: '$isExternal'"
        if ( ! $isExternal ) {
            # For user experience reasons, when the user believes they are registering an app from their own tenant,
            # we explicitly check for this. We only skip this check if they specify that they are OK with registering
            # an application owned by another tenant.
            write-verbose "Looking for existing application '$appId' in this tenant"
            $existingApp = $null
            $retryCount = 3
            $waitTime = 5

            # The directory does not guarantee read after write, and this method is often invoked after an app is created.
            # If we need to find the app, it's possible that a newly created app is not accessible by read operations
            # for some amount of time, so add a reasonable retry just in case.
            do {
                $existingApp = GetApplicationByAppId $appId
                if ( ! $existingApp ) {
                    start-sleep $waitTime
                }
                $waitTime += 10
            } while ( ! $existingApp -and --$retryCount )

            if ( ! $existingApp ) {
                throw "An application with AppId '$AppId' could not be found in this tenant -- the application may have just been created but not fully replicated or it may be from a different tenant."
            }
            write-verbose "Found existing application '$appId' in this tenant"
        }

        write-verbose "Looking for existing service principal for application '$appId' in this tenant"
        $appSP = GetAppServicePrincipal $appId

        if ( $appSP ) {
            throw "Application with Application Id '$appID' is already registered with service principal id = '$($appSP.id)'"
        }

        write-verbose "No existing service principal found for application '$appId', registering it"
        $newSP = NewAppServicePrincipal $appId

        write-verbose "Registered application '$appId' with service principal '$($newSP.id)'"
        $newSP
    }

    function NewAppServicePrincipal($appId) {
        Invoke-GraphApiRequest /servicePrincipals -method POST -body @{appId=$appId} -Version $this.version -connection $this.connection -erroraction stop -ConsistencyLevel Session
    }

    function GetAppServicePrincipal($appId, $properties, $errorAction = 'stop') {
        $selectArguments = @{}
        if ( $properties ) {
            $selectArguments['select'] = $properties
        }
        $result = Invoke-GraphApiRequest /servicePrincipals -method GET -Filter "appId eq '$appId'" -Version $this.version -connection $this.connection -erroraction $errorAction @selectArguments -ConsistencyLevel Session
        __NormalizeSearchResult $result
    }

    function GetApplicationByAppId($appId, $getServicePrincipal, $errorAction = 'stop') {
        $targetClass = if ( $getServicePrincipal ) {
            'servicePrincipals'
        } else {
            'applications'
        }

        $result = Invoke-GraphApiRequest "/$targetClass" -method GET -Filter "appId eq '$appId'" -Version $this.version -connection $this.connection -erroraction $errorAction -ConsistencyLevel Session
        __NormalizeSearchResult $result
    }

    function GetApplicationByObjectId($objectId, $getServicePrincipal, $errorAction = 'stop') {
        $targetClass = if ( $getServicePrincipal ) {
            'servicePrincipals'
        } else {
            'applications'
        }

        Invoke-GraphApiRequest "/$targetClass/$objectId" -method GET -Version $this.version -connection $this.connection -erroraction $errorAction -ConsistencyLevel Session
    }

    function GetApplicationByObjectIdOrAppId($objectId, $appId, $getServicePrincipal, $errorAction = 'stop') {
        if ( $objectId ) {
            GetApplicationByObjectId $objectId $getServicePrincipal $errorAction
        } else {
            GetApplicationByAppId $appId $getServicePrincipal $errorAction
        }
    }

    function RemoveApplicationByObjectId($objectId, $errorAction = 'stop') {
        Invoke-GraphApiRequest "/applications/$objectId" -method DELETE -Version $this.version -connection $this.connection -erroraction $erroraction -ConsistencyLevel Session | out-null
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
        $appId,
        [string[]] $delegatedPermissions,
        [string[]] $appOnlyPermissions,
        $consentRequiredPermissions,
        $userIdToConsent,
        $consentAllUsers,
        $appWithRequiredResource,
        $appServicePrincipalId
    ) {
        $isUserConsentNeeded = $false
        $consentUserId = if ( $userIdToConsent ) {
            write-verbose "User '$userIdToConsent' specified for consent"
            $isUserConsentNeeded = $true
            $userIdToConsent
        } elseif ( ! $consentAllUsers ) {
            write-verbose "No user was specified for consent, but all user consent was not specified, so consent will be made for the user making this Graph API call"
            $userObjectId = $this.connection.Identity.GetUserInformation().userObjectId
            if ( $userObjectId ) {
                $isUserConsentNeeded = $true
                write-verbose "Attempting to grant consent to app '$appId' for current user '$userObjectId'"
            } else {
                write-verbose "Unable to determine current user and all users consent not specified, so no consent for the user will be attempted; the current user is likely an app-only identity"
            }
            $userObjectId
        } else {
            write-verbose "User consent was not specified, and consent for required delegated permissions was specified, will attempt to consent those permissions for all users in the tenant"
            $isUserConsentNeeded = $true
        }

        if ( ! $isUserConsentNeeded -and ! $ConsentAllUsers -and ! $appOnlyPermissions ) {
            write-verbose "Consent for all users was not required and no specific user consent was required and no app only permissions were specified, so skipping consent completely"
            return
        }

        if ( $isUserConsentNeeded ) {
            write-verbose 'Processing user consent...'
            $grant = GetConsentGrantForApp $appId $consentUserId $DelegatedPermissions $consentRequiredPermissions $appWithRequiredResource
            if ( $grant ) {
                Invoke-GraphApiRequest /oauth2PermissionGrants -method POST -body $grant -version $this.version -connection $this.connection -ConsistencyLevel Session | out-null
            } else {
                write-verbose 'Skipping consent because no consent was specified'
            }
        }

        if ( $AppOnlyPermissions -or $consentRequiredPermissions ) {
            $targetServicePrincipalId = if ( $appServicePrincipalId ) {
                $appServicePrincipalId
            } else {
                $servicePrincipal = GetAppServicePrincipal $appId
                if ( ! $servicePrincipal -or ! ($servicePrincipal | gm id -erroraction ignore) ) {
                    throw "Application '$AppId' was not found"
                }
                $servicePrincipal.Id
            }

            write-verbose ( 'Processing app-only consent: SpecificPermissionsSpecified: {0}; ConsentRequiredPermissionsSpecified: {1}' -f ($AppOnlyPermissions -ne $null -and $AppOnlyPermissions.length -gt 0), $consentRequiredPermissions )
            ConsentAppOnlyRolesForTenant $appId $AppOnlyPermissions $consentRequiredPermissions $appWithRequiredResource $targetServicePrincipalId
        } else {
            write-verbose 'Skipping consent for app only permissions because no permissions are specified'
        }
    }

    function GetConsentGrantForApp(
        $appId,
        $consentUser,
        $scopes = @(),
        $ConsentRequiredPermissions,
        $appWithRequiredResource
    ) {
        $targetPermissions = if ( ! $ConsentRequiredPermissions ) {
            foreach ( $scopeName in $scopes ) {
                $scopeId = try {
                    $::.ScopeHelper |=> GraphPermissionNameToId $scopeName Scope
                } catch {
                }
                $canonicalScopeName = if ( $scopeId ) {
                    $::.ScopeHelper |=> GraphPermissionIdToName $scopeId Scope $null $true
                }
                if ( $canonicalScopeName ) {
                    $canonicalScopeName
                } else {
                    $scopeName
                }
            }
        } else {
            $permissions = @()
            if ( $appWithRequiredResource -and ( $appWithRequiredResource | gm requiredResourceAccess -erroraction ignore ) ) {
                $graphResourceAccess = $appWithRequiredResource.requiredResourceAccess | where resourceAppid -eq 00000003-0000-0000-c000-000000000000
                $graphResourceAccess.resourceAccess | foreach {
                    if ( $_.type -eq 'Scope') {
                        $permissionId = $_.id
                        $permissionName = $::.ScopeHelper |=> GraphPermissionIdToName $permissionId $null $this.connection
                        $permissions += $permissionName
                    }
                }
            }

            $permissions
        }

        if ( $targetPermissions -and $targetPermissions.length -gt 0 ) {
            __NewOauth2Grant $appId ($targetPermissions -join ' ') $consentUser
        }
    }

    function ConsentAppOnlyRolesForTenant(
        $appId,
        $appPermissions,
        $ConsentRequiredPermissions,
        $appWithRequiredResource,
        $appServicePrincipalId
    ) {
        $targetPermissions = if ( ! $ConsentRequiredPermissions ) {
            foreach ( $roleName in $appPermissions ) {
                $::.ScopeHelper |=> GraphPermissionNameToId $roleName 'Role' $this.connection $true
            }
        } else {
            $permissions = @()
            if ( $appWithRequiredResource -and ( $appWithRequiredResource | gm requiredResourceAccess ) ) {
                $graphResourceAccess = $appWithRequiredResource.requiredResourceAccess | where resourceAppid -eq 00000003-0000-0000-c000-000000000000

                $graphResourceAccess.resourceAccess | foreach {
                    if ( $_.type -eq 'Role') {
                        $permissions += $_.id
                    }
                }
            }

            $permissions
        }

        $appRoleAssignments = foreach ( $roleId in $targetPermissions ) {
            __NewAppRoleAssignment $appServicePrincipalId $roleId
        }

        foreach ( $assignment in $appRoleAssignments ) {
            Invoke-GraphApiRequest /servicePrincipals/$appServicePrincipalId/appRoleAssignments -method POST -body $assignment -version $this.version -connection $this.connection -ConsistencyLevel Session | out-null
        }
    }

    function GetGraphServicePrincipalId($connection) {
        $tenantId = $connection.identity.TenantDisplayId.tostring()
        $spId = $this.scriptclass.TenantToGraphServicePrincipal[$tenantId]

        if ( ! $spId ) {
            $spResult = GetAppServicePrincipal $::.ScopeHelper.GraphApplicationId @('id')
            if ( ! $spResult ) {
                throw 'Unable to find service principal for Microsoft Graph in the tenant'
            }
            $spId = $spResult.id
            $this.scriptclass.TenantToGraphServicePrincipal[$tenantId] = $spId
            write-verbose "Retrieved Graph service principal id '$spId' for tenant '$tenantId' from Graph"
        } else {
            write-verbose "Found Graph service principal id '$spId' for tenant '$tenantId' in cache"
        }

        $spId
    }

    function __NewOauth2Grant($appId, [string] $permissionName, $consentUserId) {
        $appSP = GetAppServicePrincipal $appId

        if ( ! $appSP -or ! ($appSP | gm id -erroraction ignore) ) {
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
            resourceId = GetGraphServicePrincipalId $this.connection
            principalId = $consentUserId
            scope = $permissionName
            startTime = (([DateTime]::UtcNow) - ([TimeSpan]::FromDays(1))).tostring('s')
            expiryTime = (([DateTime]::UtcNow) + ([TimeSpan]::FromDays(365))).tostring('s')
        }
    }

    function __NewAppRoleAssignment($appServicePrincipalId, [string] $roleId) {
        @{
            principalId = $appServicePrincipalId
            resourceId = GetGraphServicePrincipalId $this.connection
            principalType = 'ServicePrincipal'
            appRoleId = $roleId
            resourceDisplayName = 'Microsoft Graph'
        }
    }

    function __NormalizeSearchResult($result) {
        # Search results can return empty sets, but the search result itself
        # is non-empty, so make sure we convert a search result with no items
        # into a null result to simplify processing for callers -- they won't
        # need to inspect the payload itself for empty results
        if ( $result -and ( $result | gm -erroraction ignore id ) ) {
            $result
        }
    }
}

