#
# Module manifest for module 'AutoGraphPS-SDK'
#
# Generated by: adamedx
#
# Generated on: 9/24/2017
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'autographps-sdk.psm1'

# Version number of this module.
ModuleVersion = '0.26.0'

# Supported PSEditions
CompatiblePSEditions = @('Desktop', 'Core')

# ID used to uniquely identify this module
GUID = '4d32f054-da30-4af7-b2cc-af53fb6cb1b6'

# Author of this module
Author = 'Adam Edwards'

# Company or vendor of this module
CompanyName = 'Modulus Group'

# Copyright statement for this module
Copyright = '(c) 2021 Adam Edwards.'

# Description of the functionality provided by this module
Description = 'PowerShell SDK for Microsoft Graph automation'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('./src/cmdlets/common/Formats.ps1xml')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(@{ModuleName='scriptclass';ModuleVersion='0.20.2';Guid='9b0f5599-0498-459c-9a47-125787b1af19'})

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Clear-GraphLog'
    'Connect-GraphApi'
    'Disconnect-GraphApi'
    'Find-GraphLocalCertificate'
    'Format-GraphLog'
    'Get-GraphApplication'
    'Get-GraphApplicationCertificate'
    'Get-GraphApplicationConsent'
    'Get-GraphApplicationServicePrincipal'
    'Get-GraphConnection'
    'Get-GraphConnectionInfo'
    'Get-GraphError'
    'Get-GraphResource'
    'Get-GraphLog'
    'Get-GraphLogOption'
    'Get-GraphProfileSettings'
    'Get-GraphToken'
    'Invoke-GraphApiRequest'
    'New-GraphApplication'
    'New-GraphApplicationCertificate'
    'New-GraphConnection'
    'New-GraphLocalCertificate'
    'Register-GraphApplication'
    'Remove-GraphApplication'
    'Remove-GraphApplicationCertificate'
    'Remove-GraphApplicationConsent'
    'Remove-GraphConnection'
    'Remove-GraphResource'
    'Select-GraphProfileSettings'
    'Set-GraphApplicationConsent'
    'Set-GraphConnectionStatus'
    'Set-GraphLogOption'
    'Test-Graph'
    'Unregister-GraphApplication'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
 VariablesToExport = @(
    'AutoGraphColorModePreference'
    'GraphVerboseOutputPreference'
    'LastGraphItems'
)

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('conga', 'fgl', 'gge', 'ggr', 'gcat', 'gcon', 'Get-GraphContent', 'ggl')

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @('')

# List of all files packaged with this module
    FileList = @(
        '.\autographps-sdk.psd1'
        '.\autographps-sdk.psm1'
        '.\src\aliases.ps1'
        '.\src\cmdlets.ps1'
        '.\src\formats.ps1'
        '.\src\graph-sdk.ps1'
        '.\src\auth\AuthProvider.ps1'
        '.\src\auth\CompiledDeviceCodeAuthenticator.ps1'
        '.\src\auth\DeviceCodeAuthenticator.ps1'
        '.\src\auth\V1AuthProvider.ps1'
        '.\src\auth\V2AuthProvider.ps1'
        '.\src\client\Application.ps1'
        '.\src\client\GraphApplication.ps1'
        '.\src\client\GraphConnection.ps1'
        '.\src\client\GraphContext.ps1'
        '.\src\client\GraphIdentity.ps1'
        '.\src\client\LocalConnectionProfile.ps1'
        '.\src\client\LocalProfile.ps1'
        '.\src\client\LocalProfileSpec.ps1'
        '.\src\client\LocalSettings.ps1'
        '.\src\client\LogicalGraphManager.ps1'
        '.\src\cmdlets\Clear-GraphLog.ps1'
        '.\src\cmdlets\Connect-GraphApi.ps1'
        '.\src\cmdlets\Disconnect-GraphApi.ps1'
        '.\src\cmdlets\Find-GraphLocalCertificate.ps1'
        '.\src\cmdlets\Format-GraphLog.ps1'
        '.\src\cmdlets\Get-GraphApplication.ps1'
        '.\src\cmdlets\Get-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\Get-GraphApplicationConsent.ps1'
        '.\src\cmdlets\Get-GraphApplicationServicePrincipal.ps1'
        '.\src\cmdlets\Get-GraphConnection.ps1'
        '.\src\cmdlets\Get-GraphConnectionInfo.ps1'
        '.\src\cmdlets\Get-GraphError.ps1'
        '.\src\cmdlets\Get-GraphResource.ps1'
        '.\src\cmdlets\Get-GraphLog.ps1'
        '.\src\cmdlets\Get-GraphLogOption.ps1'
        '.\src\cmdlets\Get-GraphProfileSettings.ps1'
        '.\src\cmdlets\Get-GraphToken.ps1'
        '.\src\cmdlets\Invoke-GraphApiRequest.ps1'
        '.\src\cmdlets\New-GraphApplication.ps1'
        '.\src\cmdlets\New-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\New-GraphConnection.ps1'
        '.\src\cmdlets\New-GraphLocalCertificate.ps1'
        '.\src\cmdlets\Register-GraphApplication.ps1'
        '.\src\cmdlets\Remove-GraphApplication.ps1'
        '.\src\cmdlets\Remove-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\Remove-GraphApplicationConsent.ps1'
        '.\src\cmdlets\Remove-GraphConnection.ps1'
        '.\src\cmdlets\Remove-GraphResource.ps1'
        '.\src\cmdlets\Select-GraphProfileSettings.ps1'
        '.\src\cmdlets\Set-GraphApplicationConsent.ps1'
        '.\src\cmdlets\Set-GraphConnectionStatus.ps1'
        '.\src\cmdlets\Set-GraphLogOption.ps1'
        '.\src\cmdlets\Test-Graph.ps1'
        '.\src\cmdlets\Unregister-GraphApplication.ps1'
        '.\src\cmdlets\common\ApplicationHelper.ps1'
        '.\src\cmdlets\common\CommandContext.ps1'
        '.\src\cmdlets\common\ConsentHelper.ps1'
        '.\src\cmdlets\common\DisplayTypeFormatter.ps1'
        '.\src\cmdlets\common\DynamicParamHelper.ps1'
        '.\src\cmdlets\common\Formats.ps1xml'
        '.\src\cmdlets\common\GraphOutputFile.ps1'
        '.\src\cmdlets\common\ItemResultHelper.ps1'
        '.\src\cmdlets\common\ParameterCompleter.ps1'
        '.\src\cmdlets\common\PermissionParameterCompleter.ps1'
        '.\src\cmdlets\common\QueryHelper.ps1'
        '.\src\common\ColorString.ps1'
        '.\src\common\ColorScheme.ps1'
        '.\src\common\DefaultScopeData.ps1'
        '.\src\common\GraphAccessDeniedException.ps1'
        '.\src\common\GraphApplicationCertificate.ps1'
        '.\src\common\GraphFormatter.ps1'
        '.\src\common\GraphUtilities.ps1'
        '.\src\common\PreferenceHelper.ps1'
        '.\src\common\ProgressWriter.ps1'
        '.\src\common\ResponseContext.ps1'
        '.\src\common\ScopeHelper.ps1'
        '.\src\common\Secret.ps1'
        '.\src\graphservice\ApplicationAPI.ps1'
        '.\src\graphservice\ApplicationObject.ps1'
        '.\src\graphservice\GraphEndpoint.ps1'
        '.\src\REST\GraphErrorRecorder.ps1'
        '.\src\REST\GraphRequest.ps1'
        '.\src\REST\GraphResponse.ps1'
        '.\src\REST\HttpUtilities.ps1'
        '.\src\REST\RequestLog.ps1'
        '.\src\REST\RequestLogEntry.ps1'
        '.\src\REST\RESTRequest.ps1'
        '.\src\REST\RESTResponse.ps1'
    )

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('MSGraph', 'Graph', 'AADGraph', 'Azure', 'MicrosoftGraph', 'Microsoft-Graph', 'MS-Graph', 'AAD-Graph', 'REST', 'CRUD', 'GraphAPI', 'poshgraph', 'poshgraph-sdk', 'autograph', 'PSEdition_Core', 'PSEdition_Desktop', 'Windows', 'Linux', 'MacOS')

        # A URL to the license for this module.
        LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/adamedx/autographps-sdk'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/adamedx/poshgraph-sdk/main/assets/PoshGraphIcon.png'

        # Adds pre-release to the patch version according to the conventions of https://semver.org/spec/v1.0.0.html
        # Requires PowerShellGet 1.6.0 or greater
        # Prerelease = '-preview'

        # ReleaseNotes of this module
        ReleaseNotes = @'
## AutoGraphPS-SDK 0.26.0 Release Notes

This release adds numerous usability improvements including certificate authentication improvements, profile-based configuration, and color output along with several breaking changes.

### New dependencies

None.

### Breaking changes

* The `Connect-GraphApi` positional parameter 0 is now the new `Name` parameter, not `Permissions`. To specify permissions, this must now requires explicit specification of the `Permissions` parameter.
* The `Invoke-GraphRequest` and `Get-GraphRequest` commands were usually paging through all results by default rather than returning some default minimum -- this has been fixed
* Some fields of `Get-GraphLog` such as `HasRequestBody` have been removed
* The output of `Get-GraphApplicationConsent` now returns `Delegated` instead of `DelegatedUser` for the `PermissionType` field
* The `AADAccountsOnly` parameter for `New-GraphApplication` has been renamed to `AllowMSAAccounts` and its semantics have been reversed to match the rename. So now by default, public client apps do not allow MSA accounts, where before they would (at least if the app was multi-tenant).

### New features

* Configuration: the module now supports "Profile settings". It reads the file `~/.autographps/settings.json` on module load if it exists and sets behaviors including the initial connection according to the settings expressed in the configuration file
* The following commands related to the proflie settings feature have been added:
  * `Get-GraphProfileSettings`
  * `Select-GraphProfileSettings`
  * `Get-GraphConnection`: enumerates 'named' connections created by `New-GraphConnection` or profile settings
  * `Remove-GraphConnection`: remove named connections
* `New-GraphConnection` supports a new `Name` parameter to assign an optional name the connection. Such connections may be enumerated by the `Get-GraphConnection` command
* `Connect-GraphApi` accepts the `Name` parameter to allow connecting using settings from a named connection
* `Connect-GraphApi` now supports the `NoProfile` parameter to ignore any default connections specified in the profile
* `New-GraphApplication` now supports specifying a password for certificates that are created in the file system
* `Connect-GraphApi` supports file-system based certificates! This is required for non-Windows operating systems like Linux or MacOS that do not support the `cert:` drive
  * The existing `CertificatePath` parameter now supports file system paths in addition to Windows certificate store paths. A path to a .pfx file may be specified on any operating system
  * The `CertCredential` parameter allows specification of the certificate password -- it is mandatory when specifying a file-system based certificate using the `CertificatePath` parameter
  * The `NoCertCredential` parameter allows the password to be skipped when the `CertificatePath` parameter is specified -- this is useful when the file-system based certificate has no password.
* Support for eventual consistency, which allows for a range of rich, complex queries in exchange for those queries missing results from more recent updates to the Graph:
  * `Connect-GraphApi` and `New-GraphConnection` expose a new `ConsistencyLevel` parameter that allows specification of consistency levels including `Eventual`
  * The `Get-GraphResource` and `Invoke-GraphApi` also expose the `ConsistencyLevel` parameter to override the setting in the connection
  * The `ConsistencyLevel` option is also configurable via the new profile settings feature as part of the connection settings
* `Get-GraphLog` output is now supported by views that can be used with `Format-Table` and `Format-List`:
  * `Format-Table`: `GraphStatus`, `GraphDebug`, `GraphTiming`, `GraphAuthentication`
  * `Format-List`" `GraphDetails`
* `Get-GraphLog` output now supports COLOR! This is supported in the default view of the output as well as the other views added by `Format-Table` and `Format-List`
* Request and response size are now part of `Get-GraphLog` output -- this is true for the default `Basic` log level
* The `Get-GraphApplicationConsent` supports the `PermissionType` parameter to optionally limit the consents to just `Delegated` or just `AppOnly` consent rather than both.
* The `Invoke-GraphRequest` and `Get-GraphResource` commands now support the `All` parameter to return all results. Without this parameter, `Invoke-GraphRequest` only returns either 100 results or the number of results contained in one REST response for the particular request URI, whichever is larger.
* The `Invoke-GraphRequest` and `Get-GraphResource` commands now support the `Count` parameter to return just the count of results that would be returned and note the results themselves. This is only supported if the request URI is backed by an API that supports this capability.
* Introduced the aliases `gcon` for `Get-GraphConnectionInfo` and `conga` for `Connect-GraphApi`

### Fixed defects

* The `CertificatePath` parameter of `New-GraphConnection` and `Connect-GraphApi` was broken -- specifying it caused an error. This has been fixed and the path to a certificate in the certificate store may now be specified.
* The `Get-GraphApplicationConsent` and other commands related to consent could fail when encountering permission id's for which no known permission name mapping could be located, possibly due to using the default snapshot of mappings rather than the most recent mappings found by reading the MS Graph service principal which requires additional access.
* The `Get-GraphApplicationConsent` and `Get-GraphApplication` commands would attempt to retrieve all consents for the given application in a tenant, but this could require a very large number of requests in a tenant with large numbers of users (e.g. 10^6) for instance. They now support the `All` parameter to retrieve all consents, but by default only returns 100-200. They also support paging with `First` and `Skip` parameters
* The `OutputFilePrefix` parameter of `Invoke-GraphApiRequest` and `Get-GraphRequest` was ignored resulting in file output with only a file extension -- this was fixed to actually use the base name.
'@

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
