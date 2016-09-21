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

# This script creates default tenant networks for the tests

set -ex

HEAT_PRIVATE_SUBNET_CIDR=10.0.5.0/24

# create a heat specific private network (default 'private' network has ipv6 subnet)
source $DEST/devstack/openrc demo demo
openstack network create heat-net
neutron subnet-create --name heat-subnet heat-net $HEAT_PRIVATE_SUBNET_CIDR

# Don't use osc command till bug #1625954 is fixed
# openstack router add subnet router1 heat-subnet
neutron router-interface-add router1 heat-subnet
