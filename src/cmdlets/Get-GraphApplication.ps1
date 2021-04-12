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

. (import-script common/ApplicationHelper)

function Get-GraphApplication {
    [cmdletbinding(defaultparametersetname='appid', supportspaging=$true, positionalbinding=$false)]
    param (
        [parameter(parametersetname='appid', position=0)]
        $AppId,

        [parameter(parametersetname='objectid', mandatory=$true)]
        $ObjectId,

        [parameter(parametersetname='odatafilter', mandatory=$true)]
        $Filter,

        [parameter(parametersetname='name', mandatory=$true)]
        $Name,

        [switch] $RawContent,

        [String] $Version = $null,

        [switch] $All,

        [parameter(parametersetname='ExistingConnectionODataFilter')]
        [parameter(parametersetname='ExistingConnectionObjectId')]
        [parameter(parametersetname='ExistingConnectionName')]
        [PSCustomObject] $Connection = $null
    )
    Enable-ScriptClassVerbosePreference

    $result = $::.ApplicationHelper |=> QueryApplications $AppId $objectId $Filter $Name $RawContent $Version $null $null $connection $null $null $pscmdlet.pagingparameters.First $pscmdlet.pagingparameters.Skip $All.IsPresent

    $displayableResult = if ( $result ) {
        if ( $RawContent.IsPresent ) {
            $result
        } elseif ( $result | gm id ) {
            $result | sort-object displayname | foreach {
                $::.ApplicationHelper |=> ToDisplayableObject $_
            }
        }
    }

    if ( ! $displayableResult -and ( $AppId -and $ObjectId) ) {
        throw "The specified application could not be found."
    }

    $displayableResult
}
