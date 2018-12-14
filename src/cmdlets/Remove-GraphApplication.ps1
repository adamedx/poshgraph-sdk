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

. (import-script ../graphservice/ApplicationAPI)
. (import-script common/CommandContext)

function Remove-GraphApplication {
    [cmdletbinding(supportsshouldprocess=$true, confirmimpact='High', positionalbinding=$false)]
    param(
        [parameter(parametersetname='FromApp', position=0, valuefrompipeline=$true, mandatory=$true)]
        [parameter(parametersetname='FromAppExistingConnection', position=0, valuefrompipeline=$true, mandatory=$true)]
        $App = $null,

        [parameter(parametersetname='FromAppId', mandatory=$true)]
        [parameter(parametersetname='FromAppIdExistingConnection', mandatory=$true)]
        [Guid] $AppId,

        [parameter(parametersetname='FromObjectId', mandatory=$true)]
        [parameter(parametersetname='FromObjectIdExistingConnection', mandatory=$true)]
        [Guid] $ObjectId,

        [String] $Version = $null,

        [parameter(parametersetname='FromApp')]
        [parameter(parametersetname='FromAppId')]
        [parameter(parametersetname='FromObjectId')]
        [String[]] $Permissions = $null,

        [parameter(parametersetname='FromApp')]
        [parameter(parametersetname='FromAppId')]
        [parameter(parametersetname='FromObjectId')]
        [GraphCloud] $Cloud = [GraphCloud]::Public,

        [parameter(parametersetname='FromAppExistingConnection', mandatory=$true)]
        [parameter(parametersetname='FromAppIdExistingConnection', mandatory=$true)]
        [parameter(parametersetname='FromObjectIdExistingConnection', mandatory=$true)]
        [PSCustomObject] $Connection = $null,

        [switch] $Force
    )

    # Note that PowerShell requires us to use the begin / process / end structure here
    # in order to process more than one element of the pipeline via $App

    begin {}

    process {
        $commandContext = new-so CommandContext $connection $version $Permissions $Cloud $::.ApplicationAPI.DefaultApplicationApiVersion
        $appAPI = new-so ApplicationAPI $commandContext.connection $commandContext.version

        $targetAppDescription = ''
        $appObjectId = $null

        if ( $ObjectId ) {
            $appObjectId = $ObjectId
        } elseif ( $AppId ) {
            try {
                [Guid] $AppId | out-null
            } catch {
                throw [ArgumentException]::new("The specified App Id '$AppId' is not a valid guid")
            }

            $appObject = $appAPI |=> GetApplicationByAppId $AppId

            if ( ! $appObject -or ! ( $appObject | gm id -erroraction silentlycontinue ) ) {
                throw "Application with appid '$AppId' not found"
            }

            $targetAppDescription = "with app id '$AppId' "
            $appObjectId = $appObject.id
        } else {
            if ( ! ( $app | gm id -erroraction silentlycontinue ) ) {
                throw [ArgumentException]::new("Specified pipeline object was not a valid graph object")
            }

            # Make sure it's an app -- it must at least have an appId property
            if ( ! ( $app | gm appid -erroraction silentlycontinue ) ) {
                throw [ArgumentException]::new("Specified pipeline object was not a valid application object")
            }

            $targetAppDescription = "with app id '$($app.appId)' "

            $appObjectId = $app.id
        }

        if ( $Force.IsPresent -or $pscmdlet.shouldprocess("Application AppId = $AppId, objectId = $appObjectId", 'DELETE') ) {
            if ( $Force.IsPresent ) {
                write-verbose "Force option was specified to override confirmation, object will be deleted"
            }
            $appAPI |=> RemoveApplicationByObjectId $appObjectId
        }
    }

    end {}
}