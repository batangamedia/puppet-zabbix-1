define zabbix::resources::hostgroups (
  $hostgroup,
  $hostname,
) {

  @@zabbix_hostgroups { "${hostname}_${name}":
    hostname       => $hostname,
    hostgroup      => $hostgroup,
    zabbix_url     => '',
    zabbix_user    => '',
    zabbix_pass    => '',
    apache_use_ssl => '',
  }

}