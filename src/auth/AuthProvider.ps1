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

. (import-script ../graphservice/GraphEndpoint)

ScriptClass AuthProvider {
    $derivedProvider = $null

    function __initialize($derivedProviderClass) {
        $this.derivedProvider = new-so $derivedProviderClass.ClassName $this
    }

    function GetAuthContext($app, $graphEndpointUri, $authUri) {
        [PSCustomObject]@{
            App = $app
            GraphEndpointUri = $graphEndpointUri
            ProtocolContext = $this.derivedProvider |=> GetAuthContext $app $graphEndpointUri $authUri
        }
    }

    function GetUserInformation($token) {
        $this.serivedProvider |=> GetUserInformation $token
    }

    function AcquireInitialUserToken($authContext, $scopes) {
        $this.derivedProvider |=> AcquireInitialUserToken $authContext $scopes
    }

    function AcquireInitialAppToken($authContext, $scopes) {
        $this.derivedProvider |=> AcquireInitialAppToken $authContext $scopes
    }

    function AcquireTokenFromToken($authContext, $scopes, $token) {
        $this.derivedProvider |=> AcquireTokenFromToken $authContext $scopes $token
    }

    static {
        $providers = @{}

        function InitializeProviders {
            $this.providers.values | foreach {
                $_ |=> InitializeProvider
            }
        }

        function RegisterProvider([GraphAuthProtocol] $authProtocol, $provider) {
            $this.providers.Add($authProtocol, $provider)
        }

        function GetProviderInstance([GraphAuthProtocol] $authProtocol) {
            $protocol = if ( $authProtocol -ne ([GraphAuthProtocol]::Default) ) {
                $authProtocol
            } else {
                [GraphAuthProtocol]::V2
            }

            $providerClass = $this.providers[$protocol]

            new-so $this.ClassName $providerClass
        }
    }
}