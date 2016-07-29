require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_template_apply).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def create
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    host = @resource[:zabbix_hostname]
    templates = @resource[:template_name]
    zabbix_url = @resource[:zabbix_url]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)

    template_array = []

    if templates.is_a?(Array)
      templates.each do |template|
        template_id = self.class.get_template_id(zbx, template)
        unless template_id.nil?
          template_array.push template_id
        end
      end
    else
      template_array.push self.class.get_template_id(zbx, templates)
    end

    # Check if we need to connect via ip or fqdn
    use_ip = use_ip ? 1 : 0

    # When using DNS you still have to send a value for ip
    ipaddress = '' if ipaddress.nil? && use_ip == 0

    hostid = zbx.hosts.get_id(host: host)

    zbx.templates.mass_add(hosts_id: [hostid], templates_id: template_array)
  end