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
ModuleVersion = '0.21.0'

# Supported PSEditions
CompatiblePSEditions = @('Desktop', 'Core')

# ID used to uniquely identify this module
GUID = '4d32f054-da30-4af7-b2cc-af53fb6cb1b6'

# Author of this module
Author = 'Adam Edwards'

# Company or vendor of this module
CompanyName = 'Modulus Group'

# Copyright statement for this module
Copyright = '(c) 2020 Adam Edwards.'

# Description of the functionality provided by this module
Description = 'PowerShell SDK for automating the Microsoft Graph'

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
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(@{ModuleName='scriptclass';ModuleVersion='0.20.1';Guid='9b0f5599-0498-459c-9a47-125787b1af19'})

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Clear-GraphLog'
    'Connect-Graph'
    'Disconnect-Graph'
    'Find-GraphLocalCertificate'
    'Format-GraphLog'
    'Get-GraphApplication'
    'Get-GraphApplicationCertificate'
    'Get-GraphApplicationConsent'
    'Get-GraphApplicationServicePrincipal'
    'Get-GraphConnectionInfo'
    'Get-GraphError'
    'Get-GraphResource'
    'Get-GraphLog'
    'Get-GraphLogOption'
    'Get-GraphToken'
    'Invoke-GraphRequest'
    'New-GraphApplication'
    'New-GraphApplicationCertificate'
    'New-GraphConnection'
    'New-GraphLocalCertificate'
    'Register-GraphApplication'
    'Remove-GraphApplication'
    'Remove-GraphApplicationCertificate'
    'Remove-GraphApplicationConsent'
    'Remove-GraphItem'
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
    'GraphVerboseOutputPreference'
    'LastGraphItems'
)

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('gge', 'ggr', 'gcat', 'Get-GraphContent', 'ggl', 'fgl')

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
        '.\src\client\LogicalGraphManager.ps1'
        '.\src\cmdlets\Clear-GraphLog.ps1'
        '.\src\cmdlets\Connect-Graph.ps1'
        '.\src\cmdlets\Disconnect-Graph.ps1'
        '.\src\cmdlets\Find-GraphLocalCertificate.ps1'
        '.\src\cmdlets\Format-GraphLog.ps1'
        '.\src\cmdlets\Get-GraphApplication.ps1'
        '.\src\cmdlets\Get-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\Get-GraphApplicationConsent.ps1'
        '.\src\cmdlets\Get-GraphApplicationServicePrincipal.ps1'
        '.\src\cmdlets\Get-GraphConnectionInfo.ps1'
        '.\src\cmdlets\Get-GraphError.ps1'
        '.\src\cmdlets\Get-GraphResource.ps1'
        '.\src\cmdlets\Get-GraphLog.ps1'
        '.\src\cmdlets\Get-GraphLogOption.ps1'
        '.\src\cmdlets\Get-GraphToken.ps1'
        '.\src\cmdlets\Invoke-GraphRequest.ps1'
        '.\src\cmdlets\New-GraphApplication.ps1'
        '.\src\cmdlets\New-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\New-GraphConnection.ps1'
        '.\src\cmdlets\New-GraphLocalCertificate.ps1'
        '.\src\cmdlets\Register-GraphApplication.ps1'
        '.\src\cmdlets\Remove-GraphApplication.ps1'
        '.\src\cmdlets\Remove-GraphApplicationCertificate.ps1'
        '.\src\cmdlets\Remove-GraphApplicationConsent.ps1'
        '.\src\cmdlets\Remove-GraphResource.ps1'
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
        '.\src\cmdlets\common\GraphOutputFile.ps1'
        '.\src\cmdlets\common\ItemResultHelper.ps1'
        '.\src\cmdlets\common\ParameterCompleter.ps1'
        '.\src\cmdlets\common\PermissionParameterCompleter.ps1'
        '.\src\cmdlets\common\QueryHelper.ps1'
        '.\src\common\DefaultScopeData.ps1'
        '.\src\common\GraphAccessDeniedException.ps1'
        '.\src\common\GraphApplicationCertificate.ps1'
        '.\src\common\GraphUtilities.ps1'
        '.\src\common\PreferenceHelper.ps1'
        '.\src\common\ProgressWriter.ps1'
        '.\src\common\ScopeHelper.ps1'
        '.\src\common\Secret.ps1'
        '.\src\graphservice\ApplicationAPI.ps1'
        '.\src\graphservice\ApplicationObject.ps1'
        '.\src\graphservice\GraphEndpoint.ps1'
        '.\src\REST\GraphErrorRecorder.ps1'
        '.\src\REST\GraphRequest.ps1'
        '.\src\REST\GraphResponse.ps1'
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
## AutoGraphPS-SDK 0.20.0 Release Notes

This release includes improvements to existing commands and important fixes for major regressions in the previous release.

### New dependencies

* Microsoft.Identity.Client (MSAL) 4.14.0
* Microsoft.IdentityModel.Clients.ActiveDirectory (ADAL) 5.2.7
* `platyPS 0.14.0` (optional): Tool-only dependency. Currently only required during CI.

### Breaking changes

* The object pipeline is now explicitly supported by the `Invoke-GraphRequest` and `Get-GraphResource` commands -- graph URI's may be supplied to the pipeline and the commands will retrieve results for each URI. This may have subtle behavior differences from the previous implementation which modeled the Uri parameter as an array -- it is now a scalar object with multiple URIs available only from the pipeline and not by passing an array of URIs for the URI parameter.

### New features

* The `Get-GraphResource` command's `Select` parameter has been renamed to `Property` to be consistent with related commands in `AutoGraphPS`. However the command retains a `Select` alias for compatibility with the original parameter name and to support users accustomed to the Graph terminology for projection of a record's fields.
* The `Property` parameter (aka `Select` per above) is now the second positional parameter and `Filter` is no longer a positional parameter. Now you can use an invocation such as `Get-GraphResource me id, displayName` to get only specific properties. This change is made in part because `Filter` is seen as a less common and more advanced use case due to the need to know OData syntax. This is also consistent with other commands in related modules such as `AutoGraphPS` where `Property` is a positional parameter and `Filter` is not.
# The `Invoke-GraphRequest` and `Get-GraphResource` commands have a `NoRequest` parameter that simply returns information about the request that would be made by the command rather than issuing the request.

### Fixed defects

* The AAD Application-related commands including `Get-GraphApplication`, `New-GraphApplication`, and `Remove-GraphApplication` commands were unusable due to a breaking change to parameter names in the `0.19.0` release of this module for the `Invoke-GraphRequest` command. This release includes the fix. The affected commands were:

    * `Get-GraphApplication`
    * `Get-GraphApplicationCertificate`
    * `Get-GraphApplicationConsent`
    * `Get-GraphApplicationServicePrincipal`
    * `New-GraphApplication`
    * `New-GraphApplicationCertificate`
    * `Register-GraphApplication`
    * `Remove-GraphApplication`
    * `Remove-GraphApplicationCertificate`
    * `Remove-GraphApplicationConsent`
    * `Set-GraphApplicationConsent`
    * `Unregister-GraphApplication`

* The `Invoke-GraphRequest` and `Get-GraphResource` commands incorrectly handled the `Expand` parameter in cases where the syntax `-Expand:$false` was used -- instead of being correctly interpreted as the parameter not being specified, it was treated as if it had been expressed `-Expand`, resulting in invalid queries to Graph. This is now fixed.
* The `Descending` parameter of `Invoke-GraphRequest` and `Get-GraphResource` was ignored in the mainstream case of the `OrderBy` parameter not being hash table. This has been fixed.
* The `Skip` parameter on `Invoke-GraphRequest` and `Get-GraphResource` would generate an incorrect URI when used resulting in a `BadRequest` response from Graph -- `Skip` was unusable. This issue has been fixed.

None.

'@

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
