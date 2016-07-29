# == Class zabbix::resources::template_apply
#
# This will create an resources into puppetdb
# for automatically applying a template to an
# agent.
#
# === Requirements
#
# Template must exist, otherwise it will do nothing.
#
define zabbix::resources::template_apply (
  $template_name   = $title,
  $zabbix_hostname = undef
) {

  @@zabbix_template_apply { $template_name:
    zabbix_template => $template_name,
    zabbix_hostname => $zabbix_hostname,
    zabbix_url      => '',
    zabbix_user     => '',
    zabbix_pass     => '',
    apache_use_ssl  => '',
  }
}
