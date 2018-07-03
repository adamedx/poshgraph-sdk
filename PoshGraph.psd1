#
# Module manifest for module 'poshgraph'
#
# Generated by: adamedx
#
# Generated on: 9/24/2017
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '0.9.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '524a2b17-37b1-43c2-aa55-6c19692c6450'

# Author of this module
Author = 'Adam Edwards'

# Company or vendor of this module
CompanyName = 'Modulus Group'

# Copyright statement for this module
Copyright = '(c) 2018 Adam Edwards.'

# Description of the functionality provided by this module
Description = 'CLI for Microsoft Graph interaction'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

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
ScriptsToProcess = @('./src/graph.ps1')

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(@{ModuleName='scriptclass';ModuleVersion='0.13.6';Guid='9b0f5599-0498-459c-9a47-125787b1af19'})

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @(
        'Disconnect-Graph',
        'Connect-Graph',
        'Get-Graph',
        'Get-GraphChildItem',
        'Get-GraphConnectionStatus',
        'Get-GraphError',
        'Get-GraphItem',
        'Get-GraphLocation',
        'Get-GraphSchema',
        'Get-GraphToken',
        'Get-GraphUri',
        'Get-GraphVersion',
        'Invoke-GraphRequest',
        'New-Graph',
        'New-GraphConnection',
        'Remove-Graph',
        'Set-GraphConnectionStatus',
        'Set-GraphLocation',
        'Set-GraphPrompt',
        'Test-Graph',
        'Update-GraphMetadata'
    )

# Variables to export from this module
    VariablesToExport = @(
        'GraphAutoPromptPreference',
        'GraphMetadataPreference',
        'GraphPromptColorPreference',
        'LastGraphItems'
    )

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('gcd', 'gg', 'ggu', 'ggi', 'gls', 'gwd')

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @('')

# List of all files packaged with this module
    FileList = @(
        '.\poshgraph.psd1',
        '.\poshgraph.psm1',
        '.\src\aliases.ps1',
        '.\src\cmdlets.ps1',
        '.\src\graph.ps1',
        '.\src\client\graphapplication.ps1',
        '.\src\client\GraphConnection.ps1',
        '.\src\client\GraphContext.ps1',
        '.\src\client\graphidentity.ps1',
        '.\src\client\LogicalGraphManager.ps1',
        '.\src\cmdlets\connect-graph.ps1',
        '.\src\cmdlets\disconnect-graph.ps1',
        '.\src\cmdlets\Get-Graph.ps1',
        '.\src\cmdlets\Get-GraphChildItem.ps1',
        '.\src\cmdlets\Get-GraphConnectionStatus.ps1',
        '.\src\cmdlets\get-grapherror.ps1',
        '.\src\cmdlets\get-graphitem.ps1',
        '.\src\cmdlets\Get-GraphLocation.ps1',
        '.\src\cmdlets\Get-GraphToken.ps1',
        '.\src\cmdlets\Get-GraphUri.ps1',
        '.\src\cmdlets\get-graphversion.ps1',
        '.\src\cmdlets\invoke-graphrequest.ps1',
        '.\src\cmdlets\New-Graph.ps1',
        '.\src\cmdlets\new-graphconnection.ps1',
        '.\src\cmdlets\Remove-Graph.ps1',
        '.\src\cmdlets\Set-GraphConnectionStatus.ps1',
        '.\src\cmdlets\Set-GraphLocation.ps1',
        '.\src\cmdlets\Set-GraphPrompt.ps1',
        '.\src\cmdlets\test-graph.ps1',
        '.\src\cmdlets\Update-GraphMetadata.ps1',
        '.\src\cmdlets\common\ContextHelper.ps1',
        '.\src\cmdlets\common\ItemResultHelper.ps1',
        '.\src\cmdlets\common\LocationHelper.ps1',
        '.\src\cmdlets\common\PreferenceHelper.ps1',
        '.\src\cmdlets\common\SegmentHelper.ps1',
        '.\src\common\GraphUtilities.ps1',
        '.\src\common\ProgressWriter.ps1',
        '.\src\graphservice\graphendpoint.ps1'
        '.\src\metadata\metadata.ps1',
        '.\src\metadata\Entity.ps1',
        '.\src\metadata\EntityEdge.ps1',
        '.\src\metadata\EntityGraph.ps1',
        '.\src\metadata\EntityVertex.ps1',
        '.\src\metadata\GraphBuilder.ps1',
        '.\src\metadata\GraphCache.ps1',
        '.\src\metadata\GraphDataModel.ps1',
        '.\src\metadata\GraphSegment.ps1',
        '.\src\metadata\SegmentParser.ps1',
        '.\src\metadata\UriCache.ps1',
        '.\src\REST\grapherrorrecorder.ps1',
        '.\src\REST\graphrequest.ps1',
        '.\src\REST\graphresponse.ps1',
        '.\src\REST\restrequest.ps1',
        '.\src\REST\restresponse.ps1'
    )

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('MSGraph', 'Graph', 'AADGraph', 'Azure')

        # A URL to the license for this module.
        LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/adamedx/poshgraph'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/adamedx/poshgraph/master/assets/PoshGraphIcon.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
