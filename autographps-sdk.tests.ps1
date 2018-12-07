
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

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Describe "Poshgraph application" {
    $manifestLocation = Join-Path $here 'autographps-sdk.psd1'

    function Get-ModuleMetadataFromManifest ( $moduleName, $manifestPath ) {
        # Load the module contents and deserialize it by evaluating
        # it (module files  are just hash tables expressed as PowerShell script)
        $moduleContentLines = get-content $manifestPath
        $moduleData = $moduleContentLines | out-string | iex
        $moduleData['Name'] = $moduleName
        $moduledata
    }

    $manifest = Get-ModuleMetadataFromManifest 'autographps-sdk' $manifestlocation

    BeforeAll {
        get-job | remove-job -force
        remove-module -force scriptclass -erroraction silentlycontinue
        import-module -force scriptclass
    }

    Context "When loading the manifest" {
        It "should export the exact same set of functions as are in the set of expected functions" {
            $expectedFunctions = @(
                'New-GraphApplication',
                'new-graphconnection',
                'Remove-GraphItem',
                'Get-GraphApplication',
                'Get-GraphApplicationConsent',
                'get-graphitem',
                'Get-GraphLocalCertificate',
                'New-GraphLocalCertificate',
                'test-graph',
                'invoke-graphrequest',
                'get-graphversion',
                'get-graphschema',
                'get-grapherror',
                'connect-graph',
                'disconnect-graph',
                'Remove-GraphApplication',
                'Remove-GraphApplicationConsent',
                'Set-GraphApplicationConsent',
                'Get-GraphConnectionStatus',
                'Set-GraphConnectionStatus',
                'get-graphtoken')

            $manifest.CmdletsToExport.count | Should BeExactly $expectedFunctions.length

            $verifiedExportsCount = 0

            $expectedFunctions | foreach {
                if ( $manifest.CmdletsToExport -contains $_ ) {
                    $verifiedExportsCount++
                }
            }

            $verifiedExportsCount | Should BeExactly $expectedFunctions.length
        }
    }

    Context "When invoking the autographps-sdk application" {
        BeforeEach {
            get-job | remove-job -force
            remove-module -force 'poshgraph' 2>$null
            import-module $manifestlocation -force
        }

        AfterEach {
            get-job | remove-job -force
            remove-module -force 'autographps-sdk' 2>$null
        }

        It "Should be able to create a connection object" {
            $connection = New-GraphConnection
        }
    }
}


