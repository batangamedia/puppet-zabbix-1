# == Define zabbix::template_apply
#
#  This will apply a template to a host.
#
# === Requirements
#
# === Parameters
#
# [*templ_name*]
#  The name of the template. This name will be found in the Web interface
#
# [*zabbix_hostname*]
#  The hostname as configured in zabbix.
#
# === Example
#
#  zabbix::template { 'Template App MySQL':
#    zabbix_hostname => ::fqdn
#  }
#
# === Authors
#
# Author Name: fabio@fabiogallese.com
#
# === Copyright
#
# Copyright 2015  Fabio Gallese
#
define zabbix::template_apply (
  $templ_name   = $title,
  $zabbix_hostname = '',
) {

  zabbix::resources::template_apply { $templ_name:
    zabbix_hostname   => $zabbix_hostname,
  }
}
