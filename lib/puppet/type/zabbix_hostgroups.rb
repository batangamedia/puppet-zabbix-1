$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'puppet/util/zabbix'

Puppet::Type.newtype(:zabbix_hostgroups) do
  @doc = 'Manage zabbix hostgroups'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:hostname, namevar: true) do
    desc 'host name'
  end
  
  newparam(:hostgroup) do
    desc 'host group'
  end

  Puppet::Util::Zabbix.add_zabbix_type_methods(self)
end
