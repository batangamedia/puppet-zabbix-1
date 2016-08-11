require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_hostgroups).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def create
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    host = @resource[:hostname]
	hostgroup = @resource[:hostgroup]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    # Create the connection
    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)

    hostgroup_id = self.class.get_group_id(zbx, hostgroup)
    zbx.hostgroups.mass_add(
      hosts_id: [zbx.hosts.get_id(host: host)],
      groups_id: [hostgroup_id]
    )
  end

  def exists?
    return false
  end

  def destroy
    zabbix_url = @resource[:zabbix_url]
    self.class.require_zabbix if zabbix_url != ''
  end
end
