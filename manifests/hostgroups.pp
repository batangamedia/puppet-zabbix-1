define zabbix::hostgroups (
  $hostname = '',
  $hostgroup  = '',
) {
  if $hostgroup != '' {
    zabbix::resources::hostgroups { "${::hostname}_${name}":
      hostgroup => $hostgroup,
      hostname => $hostname,
    }
  }
}