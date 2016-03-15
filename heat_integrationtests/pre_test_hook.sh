#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# This script is executed inside pre_test_hook function in devstack gate.

set -x

localrc_path=$BASE/new/devstack/localrc
localconf=$BASE/new/devstack/local.conf

echo "CEILOMETER_PIPELINE_INTERVAL=60" >> $localrc_path
echo "HEAT_ENABLE_ADOPT_ABANDON=True" >> $localrc_path

echo -e '[[post-config|$HEAT_CONF]]\n[DEFAULT]\n' >> $localconf

if [ "$ENABLE_CONVERGENCE" == "true" ] ; then
    echo -e 'convergence_engine=true\n' >> $localconf
fi

echo -e 'notification_driver=messagingv2\n' >> $localconf
echo -e 'hidden_stack_tags=hidden\n' >> $localconf
echo -e 'encrypt_parameters_and_properties=True\n' >> $localconf

echo -e '[heat_api]\nworkers=2\n' >> $localconf
echo -e '[heat_api_cfn]\nworkers=2\n' >> $localconf
echo -e '[heat_api_cloudwatch]\nworkers=2\n' >> $localconf

echo -e '[cache]\nenabled=True\n' >> $localconf

echo -e '[[post-config|/etc/neutron/neutron_vpnaas.conf]]\n' >> $localconf
echo -e '[service_providers]\nservice_provider=VPN:openswan:neutron_vpnaas.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default\n' >> $localconf

# TODO (MRV) Temp hack to use just the no-op octavia drivers for functional tests
if [[ $OVERRIDE_ENABLED_SERVICES =~ "q-lbaasv2" ]]
then
  echo "DISABLE_AMP_IMAGE_BUILD=True" >> $localrc_path
  echo -e '[[post-config|/etc/octavia/octavia.conf]]\n' >> $localconf
  echo -e '[controller_worker]\n' >> $localconf
  echo -e 'amphora_driver = amphora_noop_driver\n' >> $localconf
  echo -e 'compute_driver = compute_noop_driver\n' >> $localconf
  echo -e 'network_driver = network_noop_driver\n' >> $localconf
fi
