# Copyright 2017, Adam Edwards
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

. (import-script RESTRequest)
. (import-script GraphEndpoint)

$AlternatePropertyMapping = @{
    'Time-Local'=@('TimeLocal', {param($val) [DateTime] $val})
    'Time-Utc'=@('TimeUtc', {param($val) [DateTime]::new(([DateTime] $val).ticks, [DateTimeKind]::Utc)})
}

function Test-Graph {
    [cmdletbinding()]
    param(
        [parameter(parametersetname='KnownClouds')] [GraphCloud] $cloud = [GraphCloud]::Public,
        [parameter(parametersetname='CustomEndpoint', mandatory=$true)] [Uri] $endpointUri
    )

    $graphEndpointUri = if ($endpointUri -eq $null ) {
        (new-so GraphEndpoint $cloud).Graph
    } else {
        $endpointUri
    }

    $pingUri = [Uri]::new($graphEndpointUri, 'ping')
    $request = new-so RESTRequest $pingUri
    $response = $request |=> Invoke

    # The [ordered] type adapter will ensure that enumeration of items in a hashtable
    # is sorted by insertion order
    $result = [ordered] @{}

    $content = $response.content
    $content | add-member -notepropertyname PingUri -notepropertyvalue $pinguri

    # Sort by name to get consistent sort formatting
    $content | gm -membertype noteproperty | sort name | foreach {
        $value = ($content | select -expandproperty $_.name)
        $mapping = $alternatePropertyMapping[$_.name]

        $destination = if ($mapping -eq $null) {
            $_.name
        } else {
            $value = invoke-command -scriptblock $mapping[1] -argumentlist $value
            $mapping[0]
        }

        $result[$destination] = $value
    }

    [PSCustomObject] $result
}
