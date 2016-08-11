define zabbix::hostgroups (
  $hostname = '',
  $hostgroup  = '',
) {
  if $hostgroup != '' {
    notify { "Estoy asignando el hostgroup $hostgroup al servidor en zabbix": }
    zabbix::resources::hostgroups { "${::hostname}_${name}":
      hostgroup => $hostgroup,
      hostname => $hostname,
    }
  }
}