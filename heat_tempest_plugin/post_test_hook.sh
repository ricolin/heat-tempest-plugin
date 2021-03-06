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

# This script is executed inside post_test_hook function in devstack gate.

set -ex

export DEST=${DEST:-/opt/stack/new}
sudo -E $DEST/heat/heat_tempest_plugin/prepare_test_env.sh
sudo -E $DEST/heat/heat_tempest_plugin/prepare_test_network.sh

cd $DEST/tempest
sudo sed -i -e '/group_regex/c\group_regex=heat_tempest_plugin\\.api\\.test_heat_api(?:\\.|_)([^_]+)' .testr.conf
sudo tempest run --regex heat_tempest_plugin

sudo -E $DEST/heat/heat_tempest_plugin/cleanup_test_env.sh
