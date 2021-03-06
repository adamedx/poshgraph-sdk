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

. (import-script ../graphservice/ApplicationAPI)
. (import-script common/CommandContext)

function Unregister-GraphApplication {
    [cmdletbinding(positionalbinding=$false)]
    param(
        [parameter(position=0, mandatory=$true)]
        [string] $AppId,

        [String] $Version = $null,

        [PSCustomObject] $Connection = $null
    )
    Enable-ScriptClassVerbosePreference

    $commandContext = new-so CommandContext $Connection $Version $null $null $::.ApplicationAPI.DefaultApplicationApiVersion
    $appAPI = new-so ApplicationAPI $commandContext.Connection $commandContext.Version

    $appSP = $appAPI |=> GetAppServicePrincipal $AppId

    if ( $appSP ) {
        write-verbose "Found service principal '$($appSP.id)' for application '$AppId'"
        $commandContext |=> InvokeRequest -uri "servicePrincipals/$($appSP.id)" -RESTMethod DELETE | out-null
    } else {
        throw "Unable to find service principal application registration object for app id '$AppId'"
    }
}

