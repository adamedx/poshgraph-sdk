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

. (import-script common/SegmentHelper)
. (import-script ../common/GraphUtilities)

function Get-GraphUri {
    [cmdletbinding()]
    param(
        [parameter(parametersetname='FromUriParents', position=0, mandatory=$true)]
        [parameter(parametersetname='FromUriChildren', position=0, mandatory=$true)]
        [parameter(parametersetname='FromUri', position=0, mandatory=$true)]
        [Uri] $Uri,

        [parameter(parametersetname='FromUriChildren', mandatory=$true)]
        [parameter(parametersetname='FromObjectChildren', mandatory=$true)]
        [Switch] $Children,

        [parameter(parametersetname='FromUriChildren')]
        [parameter(parametersetname='FromObjectChildren')]
        [Switch] $LocatableChildren,

        [parameter(parametersetname='FromUriParents', mandatory=$true)]
        [parameter(parametersetname='FromObjectParents', mandatory=$true)]
        [Switch] $Parents,

        [parameter(parametersetname='FromObjectParents', valuefrompipeline=$true, mandatory=$true)]
        [parameter(parametersetname='FromObjectChildren', valuefrompipeline=$true, mandatory=$true)]
        [parameter(parametersetname='FromObject', valuefrompipeline=$true, mandatory=$true)]
        [PSCustomObject[]]$GraphItems
    )

    $context = $::.GraphContext |=> GetCurrent
    $parser = new-so SegmentParser $context

    # This is not very honest -- we're using valuefrompipeline, but
    # only to signal the presence of input -- we use $input because
    # unless you use BEGIN, END, PROCESS blocks, you can't actually
    # iterate the parameter -- $input is a way around that
    $inputs = if ( $graphItems ) {
        $input
    } else {
        $Uri
    }

    $results = @()

    $inputs | foreach {
        $graphItem = if ($GraphItems) {
            $_
        }

        $inputUri = if ( $graphItem ) {
            if ( $graphItem | gm -membertype scriptmethod '__ItemContext' ) {
                [Uri] ($graphItem |=> __ItemContext | select -expandproperty RequestUri)
            } elseif ( $graphItem | gm Uri ) {
                [Uri] $graphItem.Uri
            } else{
                throw "Object type does not support Graph URI source"
            }
        } else {
            $::.GraphUtilities |=> ToGraphRelativeUri $uri $context
        }

        write-verbose "Uri '$graphItem' translated to '$inputUri'"

        $segments = $::.SegmentHelper |=> UriToSegments $parser $inputUri
        $lastSegment = $segments | select -last 1

        $instanceId = if ( $GraphItem ) {
            $typeData = ($lastSegment.graphElement |=> GetEntity).typedata
            if ( $typeData.IsCollection ) {
                if ( $graphItem | gm -membertype noteproperty id ) {
                    $graphItem.id
                } else {
                    '{id}'
                }
            }
        }

        $lastPublicSegment = $::.SegmentHelper |=> ToPublicSegment $parser $lastSegment

        $count = if ( $Parents.ispresent ) {
            if ( $segments -is [Object[]] ) { $segments.length } else { 1 }
        } else {
            if ( $instanceId -or $Children.ispresent ) { 0 } else { 1 }
        }

        $segments | select -last $count | foreach {
            $results += ($::.SegmentHelper |=> ToPublicSegment $parser $_)
        }

        $childSegments = $null

        if ( $instanceId ) {
            $idSegment = $lastSegment |=> NewNextSegments ($context |=> GetGraph) $instanceId

            $additionalSegments = if ( $Children.IsPresent ) {
                $childSegments = $parser |=> GetChildren $idSegment | sort Name
            } else {
                $instanceSegment = $::.SegmentHelper |=> ToPublicSegment $parser $idSegment $lastPublicSegment
                if ( $graphItem ) {
                    $instanceSegment.Content = $GraphItem
                }
                $instanceSegment
            }

            $results += $additionalSegments
        } elseif ( $Children.ispresent ) {
            $childSegments = $parser |=> GetChildren $lastSegment | sort Name
        } else {
            if ( $GraphItem ) {
                $lastOutputSegment = $results | select -last 1
                $lastOutputSegment.Content = $GraphItem
            }
        }

        if ( $childSegments ) {
            $publicChildSegments = @()
            $childSegments | foreach {
                $skipSegment = $LocatableChildren.IsPresent -and ! $::.SegmentHelper.IsValidLocationClass(($_.graphElement |=> GetEntity).Type)
                if ( ! $skipSegment ) {
                    $publicChildSegments += ($::.SegmentHelper |=> ToPublicSegment $parser $_ $lastPublicSegment)
                }
            }

            $results += $publicChildSegments
        }
    }
    $results
}

