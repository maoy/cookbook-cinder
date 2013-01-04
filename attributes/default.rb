#
# Cookbook Name:: cinder
# Attributes:: default
#
# Copyright 2012, DreamHost
# Copyright 2012, Rackspace US, Inc.
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
#

########################################################################
# Toggles - These can be overridden at the environment level
default["developer_mode"] = false  # we want secure passwords by default
########################################################################

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default["cinder"]["custom_template_banner"] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

default["cinder"]["verbose"] = "False"
default["cinder"]["debug"] = "False"

# Availability zone/region for the Cinder service
default["cinder"]["region"] = "RegionOne"

# The name of the Chef role that knows about the message queue server
# that Cinder uses
default["cinder"]["rabbit_server_chef_role"] = "rabbitmq-server"

# This is the name of the Chef role that will install the Keystone Service API
default["cinder"]["keystone_service_chef_role"] = "keystone"

# This is the name of the Chef role that will install the Glance API
default["cinder"]["glance_api_chef_role"] = "glance-api"

# operating system group name
default["cinder"]["group"] = "cinder"
# operating system user that services will run under
default["cinder"]["user"] = "cinder"

default["cinder"]["db"]["username"] = "cinder"

default["cinder"]["service_tenant_name"] = "service"
default["cinder"]["service_user"] = "cinder"
default["cinder"]["service_role"] = "admin"

# logging attribute
default["cinder"]["syslog"]["use"] = false
default["cinder"]["syslog"]["facility"] = "LOG_LOCAL2"
default["cinder"]["syslog"]["config_facility"] = "local2"

default["cinder"]["api"]["ratelimit"] = "True"

default["cinder"]["volume"]["state_path"] = "/var/lib/cinder"
default["cinder"]["volume"]["volume_driver"] = "cinder.volume.driver.ISCSIDriver"
default["cinder"]["volume"]["volume_group"] = "cinder-volumes"
default["cinder"]["volume"]["iscsi_helper"] = "tgtadm"

case platform
# FC024: Probably won't be running this on Amazon.
# when "centos", "redhat", "amazon", "scientific"
when "fedora", "redhat", "centos"
  default["cinder"]["platform"] = {
    "cinder_api_packages" => ["openstack-cinder", "python-cinderclient", "MySQL-python"],
    "cinder_api_service" => "openstack-cinder-api",
    "cinder_volume_packages" => ["openstack-cinder", "MySQL-python"],
    "cinder_volume_service" => "openstack-cinder-volume",
    "cinder_scheduler_packages" => ["openstack-cinder", "MySQL-python"],
    "cinder_scheduler_service" => "openstack-cinder-scheduler",
    "cinder_iscsitarget_packages" => ["scsi-target-utils"],
    "cinder_iscsitarget_service" => "tgtd",
    "package_overrides" => ""
  }
when "ubuntu"
  default["cinder"]["platform"] = {
    "cinder_api_packages" => ["cinder-common", "cinder-api", "python-cinderclient", "python-mysqldb"],
    "cinder_api_service" => "cinder-api",
    "cinder_volume_packages" => ["cinder-volume", "python-mysqldb"],
    "cinder_volume_service" => "cinder-volume",
    "cinder_scheduler_packages" => ["cinder-scheduler", "python-mysqldb"],
    "cinder_scheduler_service" => "cinder-scheduler",
    "cinder_iscsitarget_packages" => ["tgt"],
    "cinder_iscsitarget_service" => "tgt",
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
