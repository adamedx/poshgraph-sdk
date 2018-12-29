#
# Module manifest for module 'autographps-sdk'
#
# Generated by: adamedx
#
# Generated on: 9/24/2017
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '0.6.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '4d32f054-da30-4af7-b2cc-af53fb6cb1b6'

# Author of this module
Author = 'Adam Edwards'

# Company or vendor of this module
CompanyName = 'Modulus Group'

# Copyright statement for this module
Copyright = '(c) 2018 Adam Edwards.'

# Description of the functionality provided by this module
Description = 'PowerShell SDK for automating the Microsoft Graph'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

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
ScriptsToProcess = @('./src/graph-sdk.ps1')

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(@{ModuleName='scriptclass';ModuleVersion='0.13.7';Guid='9b0f5599-0498-459c-9a47-125787b1af19'})

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Get-DynamicValidateSetParameter')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @(
        'Connect-Graph',
        'Disconnect-Graph',
        'Find-GraphLocalCertificate',
        'Get-GraphApplication',
        'Get-GraphApplicationCertificate',
        'Get-GraphApplicationConsent',
        'Get-GraphApplicationServicePrincipal',
        'Get-GraphConnectionInfo',
        'Get-GraphError',
        'Get-GraphItem',
        'Get-GraphSchema',
        'Get-GraphToken',
        'Get-GraphVersion',
        'Invoke-GraphRequest',
        'New-GraphApplication',
        'New-GraphApplicationCertificate',
        'New-GraphConnection',
        'New-GraphLocalCertificate',
        'Register-GraphApplication',
        'Remove-GraphApplication',
        'Remove-GraphApplicationCertificate',
        'Remove-GraphApplicationConsent',
        'Remove-GraphItem',
        'Set-GraphApplicationConsent',
        'Set-GraphConnectionStatus',
        'Test-Graph',
        'Unregister-GraphApplication'
    )

# Variables to export from this module
    VariablesToExport = @(
        'GraphVerboseOutputPreference',
        'LastGraphItems'
    )

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('gge', 'ggi')

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @('')

# List of all files packaged with this module
    FileList = @(
        '.\autographps-sdk.psd1',
        '.\autographps-sdk.psm1',
        '.\src\aliases.ps1',
        '.\src\cmdlets.ps1',
        '.\src\graph-sdk.ps1',
        '.\src\auth\AuthProvider.ps1',
        '.\src\auth\V1AuthProvider.ps1',
        '.\src\auth\V2AuthProvider.ps1',
        '.\src\client\Application.ps1',
        '.\src\client\graphapplication.ps1',
        '.\src\client\GraphConnection.ps1',
        '.\src\client\GraphContext.ps1',
        '.\src\client\GraphIdentity.ps1',
        '.\src\client\LogicalGraphManager.ps1',
        '.\src\cmdlets\Connect-Graph.ps1',
        '.\src\cmdlets\Disconnect-Graph.ps1',
        '.\src\cmdlets\Find-GraphLocalCertificate.ps1',
        '.\src\cmdlets\Get-GraphApplication.ps1',
        '.\src\cmdlets\Get-GraphApplicationCertificate.ps1',
        '.\src\cmdlets\Get-GraphApplicationConsent.ps1',
        '.\src\cmdlets\Get-GraphApplicationServicePrincipal.ps1',
        '.\src\cmdlets\Get-GraphConnectionInfo.ps1',
        '.\src\cmdlets\Get-Grapherror.ps1',
        '.\src\cmdlets\Get-Graphitem.ps1',
        '.\src\cmdlets\Get-GraphSchema.ps1',
        '.\src\cmdlets\Get-GraphToken.ps1',
        '.\src\cmdlets\Get-GraphVersion.ps1',
        '.\src\cmdlets\Invoke-GraphRequest.ps1',
        '.\src\cmdlets\New-GraphApplication.ps1',
        '.\src\cmdlets\New-GraphApplicationCertificate.ps1',
        '.\src\cmdlets\New-GraphConnection.ps1',
        '.\src\cmdlets\New-GraphLocalCertificate.ps1',
        '.\src\cmdlets\Register-GraphApplication.ps1',
        '.\src\cmdlets\Remove-GraphApplication.ps1',
        '.\src\cmdlets\Remove-GraphApplicationCertificate.ps1',
        '.\src\cmdlets\Remove-GraphApplicationConsent.ps1',
        '.\src\cmdlets\Remove-GraphItem.ps1',
        '.\src\cmdlets\Set-GraphApplicationConsent.ps1',
        '.\src\cmdlets\Set-GraphConnectionStatus.ps1',
        '.\src\cmdlets\Test-Graph.ps1',
        '.\src\cmdlets\Unregister-GraphApplication.ps1',
        '.\src\cmdlets\common\ApplicationHelper.ps1',
        '.\src\cmdlets\common\CommandContext.ps1',
        '.\src\cmdlets\common\ConsentHelper.ps1',
        '.\src\cmdlets\common\DisplayTypeFormatter.ps1',
        '.\src\cmdlets\common\DynamicParamHelper.ps1',
        '.\src\cmdlets\common\ItemResultHelper.ps1',
        '.\src\cmdlets\common\ParameterCompleter.ps1',
        '.\src\cmdlets\common\PermissionParameterCompleter.ps1',
        '.\src\cmdlets\common\QueryHelper.ps1',
        '.\src\common\DefaultScopeData.ps1',
        '.\src\common\GraphAccessDeniedException.ps1',
        '.\src\common\GraphApplicationCertificate.ps1',
        '.\src\common\GraphUtilities.ps1',
        '.\src\common\PreferenceHelper.ps1',
        '.\src\common\ProgressWriter.ps1',
        '.\src\common\ScopeHelper.ps1',
        '.\src\common\Secret.ps1',
        '.\src\graphservice\ApplicationAPI.ps1',
        '.\src\graphservice\ApplicationObject.ps1'
        '.\src\graphservice\graphendpoint.ps1'
        '.\src\REST\GraphErrorRecorder.ps1',
        '.\src\REST\GraphRequest.ps1',
        '.\src\REST\GraphResponse.ps1',
        '.\src\REST\RestRequest.ps1',
        '.\src\REST\RestResponse.ps1'
    )

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('MSGraph', 'Graph', 'AADGraph', 'Azure', 'MicrosoftGraph', 'Microsoft-Graph', 'MS-Graph', 'AAD-Graph', 'REST', 'CRUD', 'GraphAPI', 'poshgraph', 'poshgraph-sdk', 'autograph')

        # A URL to the license for this module.
        LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/adamedx/poshgraph-sdk'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/adamedx/poshgraph-sdk/master/assets/PoshGraphIcon.png'

        # Adds pre-release to the patch version according to the conventions of https://semver.org/spec/v1.0.0.html
        # Requires PowerShellGet 1.6.0 or greater
        # Prerelease = '-preview'

        # ReleaseNotes of this module
        ReleaseNotes = @"
# AutoGraphPS-SDK 0.6.0 Release Notes

## New features

* Ability to dynamically obtain when possible values for permission scope names used by cmdlet auto-completion, fallback to hard-coded data
* Get-GraphApplicationServicePrincipal: advanced cmdlet to get an app service principal for use with other API's / SDK's
* Register-GraphApplication: registers a graph application in the tenant (i.e. creates its service principal)
* Unregister-GraphApplication: Removes a graph application registration from the tenant (i.e. deletes its service principal)
* Get-GraphApplicationCertificate: gets the certificates associated with the application
* New-GraphApplication: new cmdlet that creates a new Graph application!
* Get-GraphApplication: this new cmdlet retrieves specified applications from the tenant
* New-GraphLocalCertificate: new cmdlet that creates a certificate that can be used to authenticate Microsoft Graph applications
* Find-GraphLocalCertificate: new cmdlet that enumerates certificates in the local cert store used for app-only authenticate with Graph
* Get-GraphApplicationConsent: new cmdlet that lists consent grants for a Graph application
* Remove-GraphApplication: new cmdlet that deletes applications
* Remove-GraphApplicationConsent: new cmdlet that removes consent grants for a Graph application
* Set-GraphApplicationConsent: new cmdlet that updates consent grants for a Graph application
* Remove-GraphItem: this new cmdlet makes ``DELETE`` requests and supports the object pipeline -- the output of Get-GraphItem can be piped to it to delete the items for instance.
* The ``Verb`` option of ``Invoke-GraphRequest`` has been renamed to ``Method`` to match the standard set by core PowerShell commands ``Invoke-WebRequest`` and ``Invoke-RestMethod``.
* The ``Payload`` option of ``Invoke-GraphRequest`` has been renamed to ``Body`` to match the standard set by core PowerShell commands ``Invoke-WebRequest`` and ``Invoke-RestMethod``.
* Renamed Get-GraphConnectionStatus to Get-GraphConnectionInfo and added additional properties

## Fixed defects

* Get-GraphError threw exceptions trying to access not-always-present ``headers`` field
* Certificate paths specified to ``New-GraphConnection`` failed to parse when fully qualified
"@

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
