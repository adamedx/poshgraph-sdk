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
ModuleVersion = '0.4.0'

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
        'Get-GraphConnectionStatus',
        'Get-GraphError',
        'Get-GraphItem',
        'Get-GraphSchema',
        'Get-GraphToken',
        'Get-GraphVersion',
        'Invoke-GraphRequest',
        'New-GraphConnection',
        'Set-GraphConnectionStatus',
        'Test-Graph'
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
        '.\src\cmdlets\connect-graph.ps1',
        '.\src\cmdlets\disconnect-graph.ps1',
        '.\src\cmdlets\Get-GraphConnectionStatus.ps1',
        '.\src\cmdlets\get-grapherror.ps1',
        '.\src\cmdlets\get-graphitem.ps1',
        '.\src\cmdlets\Get-GraphSchema.ps1',
        '.\src\cmdlets\Get-GraphToken.ps1',
        '.\src\cmdlets\Get-GraphVersion.ps1',
        '.\src\cmdlets\Invoke-GraphRequest.ps1',
        '.\src\cmdlets\New-GraphConnection.ps1',
        '.\src\cmdlets\Set-GraphConnectionStatus.ps1',
        '.\src\cmdlets\Test-Graph.ps1',
        '.\src\cmdlets\common\ItemResultHelper.ps1',
        '.\src\cmdlets\common\DynamicParamHelper.ps1',
        '.\src\cmdlets\common\QueryHelper.ps1',
        '.\src\common\GraphAccessDeniedException.ps1',
        '.\src\common\GraphUtilities.ps1',
        '.\src\common\PreferenceHelper.ps1',
        '.\src\common\ProgressWriter.ps1',
        '.\src\common\ScopeHelper.ps1',
        '.\src\common\Secret.ps1',
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
# AutoGraphPS-SDK 0.4.0 Release Notes
The release renames the PoshGraph-SDK PowerShell module to AutoGraphPS-SDK.

# AutoGraphPS-SDK 0.3.0 Release Notes -- previous release

This release adds support for app authentication and cmdlet argument completion.

## New features

### Cmdlet features
* V1 auth protocol token caching introduced -- no need to re-authenticate every hour for V1 auth
* App-only auth through ``New-GraphConnection`` for v1 and v2 auth protocols via symmetric key or certificate
  * Use ``-NonInteractiveAppAuth`` of ``New-GraphConnection`` for app only auth and specify one of the following options
    * ``-Secret`` to specify a symmetric key through the ``-Password`` parameter
    * ``-CertificatePath`` to specify a path to a ceritificate in the local certificate store PowerShell drive ``cert:``.
    * ``-Certificate`` to specify an ``X509Certificate2`` describing an ``X509`` certificate with a private key such as one that can be obtained by reading a certificate from the local certificate store or from any number of serialized certificate file formats such as ``.pfx``, ``.cer``, etc.
  * The connection returned by ``New-GraphConnection`` can be supplied to the ``-Connection`` parameter of the ``Connect-Graph`` cmdlet or other cmdlets that accept the ``-Connection`` parameter obtain and use an app-only access token
* Argument completion for ``ScopeNames`` parameter of ``Connect-Graph`` and ``New-GraphConnection`` cmdlets
  * Associated ``-SkipScopeValidation`` option to allow scope names not validated / completed by the cmdlet
* Parameter ``-GraphAuthProtocol`` has been changed to ``-AuthProtocol`` for the ``New-GraphConnection`` cmdlet
* ``-Search`` option added to ``Get-GraphItem`` and ``Invoke-GraphRequests`` cmdlets to enable full-text search on Graph REST calls that support the OData ```$search`` query parameter

#### Feature notes
* For app-only auth: If ``-Secret`` is specified but ``-Password`` is not specified, you will receive a secure input prompt to allow you to implement the symmetric key password from the console.
* For the ``-CertificatePath`` parameter, if the specified path to the certificate in the PowerShell ``cert:`` drive is not an absolute path starting with ``cert:/``, the path is assumed to be relative to the user's certificate story, i.e. ``cert://currentuser/my``.

### Library features

* Expose tenant display information from the ``GraphIdentity`` class.
* Refactor of authentication related code

## Fixed defects

* Fix incorrect auth protocol used due to shared reference corruption issue in data structure
* Fix token cache not being cleared when connection was disconnected
* Fix confusing parameter sets for ``New-GraphConnection`` and ``Connect-Graph`` with simpler permutations
"@

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}