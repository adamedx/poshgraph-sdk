# Copyright 2019, Adam Edwards
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

Describe "ParameterCompleter class" {

    Context "FindMatchesStartingWith method" {
        $matchatstart = @('first')
        for ( $i = 0; $i -lt 10; $i++ ) { $matchatstart += @("everythingelse$($i)") }

        $matchatend = @()
        for ( $i = 0; $i -lt 10; $i++ ) { $matchatend += @("everythingbefore$($i)") }
        $matchatend += 'last'

        $testLists = @{
            sampleTargetsList = @( "activities", "calendar", "calendarGroups", "calendars", "calendarView", "contactFolders", "contacts",
                            "createdObjects", "deviceManagementTroubleshootingEvents", "directReports", "drive", "drives", "events",
                            "extensions", "inferenceClassification", "insights", "joinedTeams", "licenseDetails", "mailFolders",
                            "managedAppRegistrations", "managedDevices", "manager", "memberOf", "messages", "onenote", "outlook",
                            "ownedDevices", "ownedObjects", "people", "photo", "photos", "planner", "registeredDevices", "settings" )
            emptyList = @()
            singlelist = @('oneitem')
            twolist = @('one', 'two')
            threelist = @('one', 'two', 'three')
            fourlist = @('one', 'two', 'three', 'four')
            matchatstart = $matchatstart
            matchatend = $matchatend
        }

        function GetExpectedMatches($target, $candidates) {
            $normalized = $target.tolowerinvariant()
            $candidates | where { $_.tolowerinvariant().startswith($normalized) } | sort-object
        }

        function CompareResults($target, $candidates, $truncationLength) {
            $adjustedTarget = if ( ! $truncationLength ) {
                $target
            } else {
                $target.substring(0, $truncationLength)
            }

            # Need to ensure case insensitive sort on Linux
            $sortedInsensitiveCandidates = $candidates | foreach { $_.tolowerinvariant() } | sort-object

            $expected = GetExpectedMatches $adjustedTarget @($sortedInsensitiveCandidates)
            $actual = $::.ParameterCompleter |=> FindMatchesStartingWith $adjustedTarget @($sortedInsensitiveCandidates)
            if ( ! $expected ) {
                $actual
            } else {
                compare-object -referenceobject $expected -differenceobject $actual
            }
        }


        It 'Should return nothing for an empty list and not raise an exception' {
            { $::.ParameterCompleter |=> FindMatchesStartingWith '' @() } | Should Not Throw
            { $::.ParameterCompleter |=> FindMatchesStartingWith 'me' @() } | Should Not Throw

            $::.ParameterCompleter |=> FindMatchesStartingWith '' @() | Should Be @()
            $::.ParameterCompleter |=> FindMatchesStartingWith me @() | Should Be @()
        }

        It 'Should return the only element in the list' {
            CompareResults $testlists.singlelist[0] $testlists.singlelist | Should Be $null
        }

        It "Should return at least an exact match for each element in every sample list" {
            $testlists.keys | foreach {
                $currentList = $testlists[$_] | sort-object
                $currentList | foreach {
                    CompareResults $_ $currentList | Should Be $null
                    # When checking results, make comparisons insensitive via tolowerinvariant()
                    # to deal with with case sensitivity on Linux
                    $matchResults = $::.ParameterCompleter |=> FindMatchesStartingWith $_.tolowerinvariant() ($currentList | foreach { $_.tolowerinvariant() } | sort-object )
                    $_.tolowerinvariant() | Should BeIn $matchResults
                }
            }
        }

        It "Should return at least an exact match for each element truncated to 1 char in every sample list" {
            $testlists.keys | foreach {
                $currentList = $testlists[$_] | sort-object
                $currentList | foreach {
                    CompareResults $_ $currentList 1 | Should Be $null
                }
            }
        }

        It "Should return at least an exact match for each element truncated to 2 chars in every sample list" {
            $testlists.keys | foreach {
                $currentList = $testlists[$_] | sort-object
                $currentList | foreach {
                    CompareResults $_ $currentList 2 | Should Be $null
                }
            }
        }

        It "Should return at least an exact match for each element truncated to 3 chars in every sample list" {
            $testlists.keys | foreach {
                $currentList = $testlists[$_] | sort-object
                $currentList | foreach {
                    CompareResults $_ $currentList 3 | Should Be $null
                }
            }
        }

        It "Should return matches for a substring that matches every word except the first" {
            $expected = $matchatstart | select -last ($matchatstart.length - 1)
            $actual = $::.ParameterCompleter |=> FindMatchesStartingWith 'ever' $matchatstart
            compare-object -referenceobject $expected -differenceobject $actual | Should Be $null
        }

        It "Should return matches for a substring that matches every word except the last" {
            $expected = $matchatend | select -first ($matchatend.length - 1)
            $actual = $::.ParameterCompleter |=> FindMatchesStartingWith 'ever' $matchatend
            compare-object -referenceobject $expected -differenceobject $actual | Should Be $null
        }

        It "Should return all the words starting with 'calend' when 'calend' is given in a list containing 4 words starting with 'calendar'" {
            $expected = @( "calendar", "calendarGroups", "calendars", "calendarView" )
            $actual = $::.ParameterCompleter |=> FindMatchesStartingWith 'calend' $testlists.sampleTargetsList
            compare-object -referenceobject $expected -differenceobject $actual | Should Be $null
        }
    }
}
