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
. (import-script New-GraphConnection)

function Invoke-GraphRequest {
    [cmdletbinding(positionalbinding=$false)]
    param(
        [parameter(position=0, mandatory=$true)][String] $RelativeUri = $null,
        [parameter(position=1)][String] $Verb = 'GET',
        [parameter(position=2, valuefrompipeline=$true)] $Payload = $null,
        [String] $Version = $null,
        [parameter(parametersetname='NewConnection')][switch] $AADGraph,
        [parameter(parametersetname='NewConnection')][String] $AADTenantId = $null,
        [parameter(parametersetname='NewConnection')][GraphCloud] $Cloud = [GraphCloud]::Public,
        [parameter(parametersetname='ExistingConnection', mandatory=$true)][PSCustomObject] $Connection = $null
    )

    $defaultVersion = $null
    $graphType = if ($Connection -ne $null ) {
        $Connection.GraphEndpoint.Type
    } elseif ( $AADGraph.ispresent ) {
        ([GraphType]::AADGraph)
    } else {
        ([GraphType]::MSGraph)
    }

    switch ($graphType) {
        ([GraphType]::AADGraph) { $defaultVersion = '1.6' }
        ([GraphType]::MSGraph) { $defaultVersion = 'v1.0' }
        default {
            throw "Unexpected identity type '$graphType'"
        }
    }

    $apiVersion = if ( $Version -eq $null -or $version.length -eq 0 ) {
        $defaultVersion
    } else {
        $Version
    }

    $graphConnection = if ( $Connection -eq $null ) {
        $connectionArguments = @{Cloud=$Cloud}
        if ( $AADGraph.ispresent ) {
            $connectionArguments = @{AADGraph = $AADGraph;AADTenantId = $AADTenantId}
        }
        New-GraphConnection @connectionArguments
    } else {
        $Connection
    }

    $tenantQualifiedVersionSegment = if ( $graphType -eq ([GraphType]::AADGraph) ) {
        $AADTenantId
    } else {
        $apiVersion
    }

    $graphRelativeUri = $tenantQualifiedVersionSegment, $relativeUri -join '/'

    if ( $graphType -eq ([GraphType]::AADGraph) ){
        $graphRelativeUri = $graphRelativeUri, "api-version=$apiVersion" -join '?'
    }

    $graphUri = [Uri]::new($graphConnection.GraphEndpoint.Graph, $graphRelativeUri)

    $graphConnection |=> Connect

    $headers = @{
        'Content-Type'='application\json'
        'Authorization'=$graphConnection.Identity.token.CreateAuthorizationHeader()
    }

    $request = new-so RESTRequest $graphUri $Verb $headers
    $response = $request |=> Invoke

    $response.content
}