# Copyright 2021, Adam Edwards
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

. (import-script PreferenceHelper)
. (import-script ColorScheme)

ScriptClass ColorString {
    static {
        const ALLOWED_COLOR_MODES 2bit, 4bit
        const ESCAPE_CHAR "$([char]0x1b)"
        const END_COLOR "$($ESCAPE_CHAR)[0m"

        $supportsColor = $host.ui.SupportsVirtualTerminal

        $standardColorings = @('Emphasis1', 'Emphasis2', 'Containment', 'EnabledState', 'Success', 'Error1', 'Error2', 'Error3', 'Contrast', 'Scheme')

        $standardMapping = @{
            '2Bit' = @{}
            '4bit' = @{
                Emphasis1 = 11
                Emphasis2 = 14
                Containment = 14
                Disabled = 8
                Enabled = 10
                Success = 10
                Error1 = 1
                Error2 = 9
                Error3 = 1
                Contrast = @(14, 12, 13)
            }
        }

        $colorMaps = @{
            '2bit' = @{}
            '4bit' = @{}
        }

        $color16NameMap = @{
            Black = 0
            DarkBlue = 4
            DarkGreen = 2
            DarkCyan = 6
            DarkRed = 1
            DarkMagenta = 5
            DarkYellow = 3
            Gray = 7
            DarkGray = 8
            Blue = 12
            Green = 10
            Cyan = 14
            Red = 9
            Magenta = 13
            Yellow = 11
            White = 15
        }

        $color16Contrast = @{
            0 = 15
            1 = 15
            2 = 15
            3 = 0
            4 = 15
            5 = 15
            6 = 0
            7 = 0
            8 = 0
            9 = 0
            10 = 0
            11 = 0
            12 = 15
            13 = 15
            14 = 0
            15 = 0
        }

        function GetColorFromName([string] $colorName) {
            $this.color16NameMap[$colorName]
        }

        function GetColorContrast($color) {
            $this.color16Contrast[$color]
        }

        function UpdateColorScheme([PSCustomObject[]] $colorInfoObjects) {
            $newScheme = new-so ColorScheme @($colorInfoObjects)

            foreach ( $colorMode in $this.colorMaps.Keys ) {
                $colorMap = $newScheme |=> GetColorMap $colorMode

                if ( $colorMap ) {
                    foreach ( $colorName in $colorMap.keys ) {
                        $this.colorMaps[$colorMode][$colorName] = $colorMap[$colorName]
                    }
                }
            }
        }

        function ToStandardColorString($output, [string] $coloring, $criterion, [object[]] $highlightedValues, $disabledValue) {
            if ( $this.standardColorings -notcontains $coloring ) {
                $output
                return
            }

            $targetCriterion = if ( $criterion ) {
                $criterion
            } else {
                $output
            }

            $colors = GetStandardColors $coloring $targetCriterion $highlightedValues $disabledValue

            if ( ( $colors[0] -ne $null ) -or ( $colors[1] -ne $null ) ) {
                ToColorString $output $colors[0] $colors[1]
            } else {
                $output
            }
        }

        function GetStandardColors([string] $coloring, $criterion, [object[]] $highlightedValues, $disabledValue) {
            if ( $this.standardColorings -notcontains $coloring ) {
                $null, $null
                return
            }

            $colorMode = GetColorMode

            $colorMapping = $this.standardMapping[$colorMode]

            $standardColor = switch ( $coloring ) {
                'Scheme' {
                    if ( $this.colorMaps[$colorMode] -ne $null ) {
                        $this.colorMaps[$colorMode][$criterion]
                    }
                }
                'Emphasis1' {
                    $colorMapping['Emphasis1']
                }
                'Emphasis2' {
                    $colorMapping['Emphasis2']
                }
                'Containment' {
                    $colorMapping['Containment']
                }
                'EnabledState' {
                    if ( $criterion -eq $disabledValue ) {
                        $colorMapping['Disabled']
                    } elseif ( $criterion -in $highlightedValues ) {
                        $colorMapping['Enabled']
                    }
                }
                'Success' {
                    $colorMapping['Success']
                }
                'Error1' {
                    $colorMapping['Error1']
                }
                'Error2' {
                    $colorMapping['Error2']
                }
                'Error3' {
                    $colorMapping['Error3']
                }
                'Contrast' {
                    if ( $criterion -eq $disabledValue ) {
                        $colorMapping['Disabled']
                    } elseif ( $highlightedValues ) {
                        $valueIndex = $highlightedValues.IndexOf($criterion)
                        if ( $valueIndex -ge 0 ) {
                            $colorVector = $colorMapping['Contrast']
                            $colorVector[$valueIndex % $colorVector.Length]
                        }
                    }
                }
            }

            $foregroundColor = $null
            $backgroundColor = $null

            if ( $standardColor ) {
                if ( $coloring -eq 'Containment' -or $coloring -eq 'Error1' ) {
                    $backgroundColor = $standardColor
                    $foregroundColor = 0
                } else {
                    $foregroundColor = $standardColor
                }
            }

            $foregroundColor, $backgroundColor
        }

        function ToColorString([string] $text, $foreColor, $backColor) {
            $colorMode = GetColorMode

            if ( ! $colorMode -or $colorMode -eq '2bit' ) {
                $text
                return
            }

            $colorString = GetColorStringFromIndex $foreColor $backColor

            if ( $colorString ) {
                "$colorString$($text)$END_COLOR"
            } else {
                $text
            }
        }

        function GetColorStringFromIndex($foreColor, $backColor) {
            $hasColor = $false
            $hasBoth = $false

            $backValue = 0

            if ( $backColor -ne $null ) {
                $backOffset = RemapColorIndex $backColor
                if ( $backOffset -ne $null ) {
                    $hasColor = $true
                    $backValue = 40 + $backOffset
                }
            }

            $foreValue = 0

            if ( $foreColor -ne $null ) {
                $frontOffset = RemapColorIndex $foreColor
                if ( $frontOffset -ne $null ) {
                    $hasBoth = $hasColor
                    $hasColor = $true
                    $foreValue = 30 + $frontOffset
                }
            }

            if ( $hasColor ) {
                $colorString = "$ESCAPE_CHAR["

                if ( $foreColor -ne $null ) {
                    $colorString += "$foreValue"
                }

                if ( $hasBoth ) {
                    $colorString += ";"
                }

                if ( $backColor -ne $null ) {
                    $colorString += "$backValue"
                }

                "$($colorString)m"
            }
        }

        function RemapColorIndex([int32] $index) {
            if ( $index -lt 8 ) {
                $index
            } elseif ( $index -lt 16 ) {
                $index - 8 + 60
            }
        }

        function GetColorMode {
            if ( $this.supportsColor ) {
                $colorVar = get-variable AutoGraphColorModePreference -value -erroraction ignore

                if ( $colorVar -eq '4bit' ) {
                    '4bit'
                } else {
                    '2bit'
                }
            } else {
                '2bit'
            }
        }
    }
}

