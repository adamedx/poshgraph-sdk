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

. (import-script ../graphservice/GraphEndpoint)
. (import-script ../client/GraphIdentity)
. (import-script ../common/GraphApplicationCertificate)
. (import-script ../client/GraphConnection)
. (import-script common/DynamicParamHelper)
. (import-script ../common/ScopeHelper)
. (import-script common/PermissionParameterCompleter)

function New-GraphConnection {
    [cmdletbinding(positionalbinding=$false, DefaultParameterSetName='msgraph')]
    param(
        [parameter(parametersetname='msgraph', position=0)]
        [parameter(parametersetname='cloud', position=0)]
        [parameter(parametersetname='customendpoint', position=0)]
        [parameter(parametersetname='cert', position=0)]
        [parameter(parametersetname='certpath', position=0)]
        [parameter(parametersetname='autocert', position=0)]
        [parameter(parametersetname='secret', position=0)]
        [String[]] $Permissions = $null,

        [parameter(parametersetname='msgraph')]
        [parameter(parametersetname='cloud')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='customendpoint')]
        [parameter(parametersetname='autocert')]
        $AppId = $null,

        [parameter(parametersetname='msgraph')]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [parameter(parametersetname='autocert')]
        [parameter(parametersetname='customendpoint')]
        [Switch] $NoninteractiveAppOnlyAuth,

        [String] $TenantId = $null,

        [parameter(parametersetname='certpath', mandatory=$true)]
        [parameter(parametersetname='customendpoint')]
        [string] $CertificatePath = $null,

        [parameter(parametersetname='cert', mandatory=$true)]
        [parameter(parametersetname='customendpoint')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate = $null,

        [switch] $Confidential,

        [parameter(parametersetname='secret', mandatory=$true)]
        [parameter(parametersetname='customendpoint')]
        [Switch] $Secret,

        [parameter(parametersetname='secret', mandatory=$true)]
        [parameter(parametersetname='customendpoint')]
        [SecureString] $Password,

        [parameter(parametersetname='msgraph')]
        [parameter(parametersetname='cloud', mandatory=$true)]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='autocert')]
        [validateset("Public", "ChinaCloud", "GermanyCloud", "USGovernmentCloud")]
        [string] $Cloud = $null,

        [alias('ReplyUrl')]
        [Uri] $AppRedirectUri,

        [Switch] $NoBrowserSigninUI,

        [parameter(parametersetname='customendpoint', mandatory=$true)]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [Uri] $GraphEndpointUri = $null,

        [parameter(parametersetname='customendpoint', mandatory=$true)]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [Uri] $AuthenticationEndpointUri = $null,

        [parameter(parametersetname='customendpoint')]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [Uri] $GraphResourceUri = $null,

        [parameter(parametersetname='msgraph')]
        [parameter(parametersetname='secret')]
        [parameter(parametersetname='cert')]
        [parameter(parametersetname='certpath')]
        [parameter(parametersetname='customendpoint')]
        [ValidateSet('Default', 'v1', 'v2')]
        [string] $AuthProtocol = 'Default',

        [parameter(parametersetname='msgraph')]
        [parameter(parametersetname='customendpoint')]
        [ValidateSet('Auto', 'AzureADOnly', 'AzureADAndPersonalMicrosoftAccount')]
        [string] $AccountType = 'Auto',

        [string] $Name = $null,

        [ValidateSet('Auto', 'Default', 'Session', 'Eventual')]
        [string] $ConsistencyLevel = 'Auto',

        [parameter(parametersetname='aadgraph', mandatory=$true)]
        [parameter(parametersetname='customendpoint')]
        [switch] $AADGraph,

        [String] $UserAgent = $null
    )

    begin {
    }

    process {
        Enable-ScriptClassVerbosePreference

        $validatedCloud = if ( $Cloud ) {
            [GraphCloud] $Cloud
        } else {
            ([GraphCloud]::Public)
        }

        $graphType = if ( $AADGraph.ispresent ) {
            ([GraphType]::AADGraph)
        } else {
            ([GraphType]::MSGraph)
        }

        $specifiedAuthProtocol = if ( $AuthProtocol -ne ([GraphAuthProtocol]::Default) ) {
            $AuthProtocol
        }

        $specifiedScopes = if ( $Permissions ) {
            if ( $Secret.IsPresent -or $Certificate -or $CertificatePath ) {
                throw 'Permissions may not be specified for app authentication'
            }
            $Permissions
        } else {
            @('User.Read')
        }

        $computedAuthProtocol = $::.GraphEndpoint |=> GetAuthProtocol $AuthProtocol $validatedCloud $GraphType

        $noAppSpecified = $false

        $targetAppId = if ( $appId ) {
            $appId
        } else {
            $noAppSpecified = $true
            $::.Application.DefaultAppId
        }

        $allowMSA = $AccountType -eq 'AzureADAndPersonalMicrosoftAccount'

        if ( ! $allowMSA -and $AccountType -eq 'Auto' ) {
            # The default app supports MSA
            $allowMSA = $noAppSpecified
        }

        if ( $GraphEndpointUri -eq $null -and $AuthenticationEndpointUri -eq $null -and $specifiedAuthProtocol -and $appId -eq $null ) {
            write-verbose 'Simple connection specified with no custom uri, auth protocol, or app id'
            $::.GraphConnection |=> NewSimpleConnection $graphType $validatedCloud $specifiedScopes $false $TenantId $computedAuthProtocol -useragent $UserAgent -allowMSA $allowMSA $ConsistencyLevel
        } else {
            $graphEndpoint = if ( $GraphEndpointUri -eq $null ) {
                write-verbose 'Custom endpoint data required, no graph endpoint URI was specified, using URI based on cloud'
                write-verbose ("Creating endpoint with cloud '{0}', auth protocol '{1}'" -f $validatedCloud, $computedAuthProtocol)
                new-so GraphEndpoint $validatedCloud $graphType $null $null $computedAuthProtocol $GraphResourceUri
            } else {
                write-verbose ("Custom endpoint data required and graph endpoint URI was specified, using specified endpoint URI and auth protocol {0}'" -f $computedAuthProtocol)
                new-so GraphEndpoint ([GraphCloud]::Custom) ([GraphType]::MSGraph) $GraphEndpointUri $AuthenticationEndpointUri $computedAuthProtocol $GraphResourceUri
            }

            $adjustedTenantId = $TenantId

            $appSecret = if ( $Confidential.IsPresent -or $NoninteractiveAppOnlyAuth.IsPresent ) {
                if ( $Password ) {
                    $Password
                } elseif ( $Certificate ) {
                    $Certificate
                } elseif ( $CertificatePath ) {
                    $CertificatePath
                } else {
                    $appCertificate = $::.GraphApplicationCertificate |=> FindAppCertificate $targetAppId
                    if ( ! $appCertificate ) {
                        throw "NoninteractiveAppOnlyAuth or Confidential was specified, but no password or certificate was specified, and no certificate with the appId '$targetAppId' in the subject name could be found in the default certificate store location. Specify an explicit certificate or password and retry."
                    } elseif ( ($appCertificate -is [object[]] ) -and $appCertificate.length -gt 1 ) {
                        throw "NoninteractiveAppOnlyAuth or Confidential was specified, and more than one certificate with the appId '$targetAppId' in the subject name could be found in the default certificate store location. Specify an explicit certificate or password and retry. `n$($appCertificate.PSPath)`n"
                    }
                    $appCertificate
                }

                if ( ! $TenantId ) {
                    write-verbose "No tenant id was specified and app is non-interactive, attempting to get tenant id from current token"
                    $inferredTenantId = ('GraphContext' |::> GetConnection).Identity |=> GetTenantId

                    if ( ! $inferredTenantId ) {
                        throw [ArgumentException]::new("No tenant was specified for app-only auth, and a tenant could not be inferred from the current token -- specify a tenant id with the -TenantId parameter and retry the command.")
                    }

                    $adjustedTenantId = $inferredTenantId
                }
            }

            $app = new-so GraphApplication $targetAppId $AppRedirectUri $appSecret $NoninteractiveAppOnlyAuth.IsPresent
            $identity = new-so GraphIdentity $app $graphEndpoint $adjustedTenantId $allowMSA
            new-so GraphConnection $graphEndpoint $identity $specifiedScopes $NoBrowserSigninUI.IsPresent $userAgent $Name $ConsistencyLevel
        }
    }
}

$::.ParameterCompleter |=> RegisterParameterCompleter New-GraphConnection Permissions (new-so PermissionParameterCompleter ([PermissionCompletionType]::AnyPermission))
