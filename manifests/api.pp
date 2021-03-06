# == Class designate::api
#
# Configure designate API service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*api_package_name*]
#  (optional) Name of the package containing api resources
#  Defaults to $::designate::paramas::api_package_name
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate api service will be running.
#  Defaults to 'running'
#
# [*auth_strategy*]
#  (optional) Authentication strategy to use, can be either "noauth" or
#  "keystone"
#  Defaults to 'noauth'
#
# [*enable_api_v1*]
#  (optional) Enable Designate API Version 1
#  Defaults to true
#
# [*enable_api_v2*]
#  (optional) Enable Designate API Version 2 (experimental)
#  Defaults to false
#
# [*enable_api_admin*]
#  (optional) Enable Designate Admin API
#  Defaults to false.
#
# [*api_host*]
#  (optional) Address to bind the API server
#  Defaults to '0.0.0.0'
#
# [*api_port*]
#  (optional) Port the bind the API server to
#  Defaults to '9001'
#
# [*api_base_uri*]
#  Set the base URI of the Designate API service.
#
class designate::api (
  $package_ensure             = present,
  $api_package_name           = $::designate::params::api_package_name,
  $enabled                    = true,
  $service_ensure             = 'running',
  $auth_strategy              = 'noauth',
  $enable_api_v1              = true,
  $enable_api_v2              = false,
  $enable_api_admin           = false,
  $api_host                   = '0.0.0.0',
  $api_port                   = '9001',
  $api_base_uri               = $::os_service_default,
) inherits designate {

  # API Service
  designate_config {
    'service:api/api_host'                  : value => $api_host;
    'service:api/api_port'                  : value => $api_port;
    'service:api/auth_strategy'             : value => $auth_strategy;
    'service:api/enable_api_v1'             : value => $enable_api_v1;
    'service:api/enable_api_v2'             : value => $enable_api_v2;
    'service:api/enable_api_admin'          : value => $enable_api_admin;
    'service:api/api_base_uri'              : value => $api_base_uri;
  }

  if $auth_strategy == 'keystone' {
    include ::designate::keystone::authtoken
  }

  designate::generic_service { 'api':
    enabled        => $enabled,
    manage_service => $service_ensure,
    ensure_package => $package_ensure,
    package_name   => $api_package_name,
    service_name   => $::designate::params::api_service_name,
  }
}
