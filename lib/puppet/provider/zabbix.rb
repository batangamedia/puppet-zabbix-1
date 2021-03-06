# zabbix provider type for puppet
class Puppet::Provider::Zabbix < Puppet::Provider
  # Require the zabbixapi gem
  def self.require_zabbix
    require 'zabbixapi'
  end

  # Create the api connection
  def self.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    protocol = apache_use_ssl ? 'https' : 'http'
    zbx = ZabbixApi.connect(
      url: "#{protocol}://#{zabbix_url}/api_jsonrpc.php",
      user: zabbix_user,
      password: zabbix_pass
    )
    zbx
  end

  # Check if host exists. When error raised, return false.
  def self.check_host(host, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx = create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx.hosts.get_id(host: host)
  rescue Puppet::ExecutionFailure
    false
  end

  # Check if proxy exists. When error raised, return false.
  def self.check_proxy(host, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    require_zabbix
    zbx = create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx.proxies.get_id(host: host)
  rescue Puppet::ExecutionFailure
    false
  end

  # Get the template id from the name.
  def self.get_template_id(zbx, template)
    return template if a_number?(template)
    zbx.templates.get_id(host: template)
  end

  def self.get_group_id(zbx, group)
    return group if a_number?(group)
    zbx.hostgroups.get_id(name: group)
  end

  # Check if given template name exists in current host.
  def self.check_template_in_host(host, template, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx = create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    template_id = get_template_id(zbx, template)
    template_array = zbx.templates.get_ids_by_host(hostids: [zbx.hosts.get_id(host: host)])
    template_array.include?(template_id.to_s)
  end

  def self.check_template_exist(template, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx = create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx.templates.get_id(host: template)
  rescue Puppet::ExecutionFailure
    false
  end

  def self.check_template_is_equal(template, template_source, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx = create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    exported = zbx.configurations.export(
      format: 'xml',
      options: {
        templates: [zbx.templates.get_id(host: template)]
      }
    )
    exported_clean = exported.gsub(%r{>\s*}, '>').gsub(%r{\s*<}, '<').gsub(%r{<date>.*<\/date>}, 'DATEWASHERE')
    template_source_clean = template_source.gsub(%r{>\s*}, '>').gsub(%r{\s*<}, '<').gsub(%r{<date>.*<\/date>}, 'DATEWASHERE')
    exported_clean.eql? template_source_clean
  rescue Puppet::ExecutionFailure
    false
  end

  # Is it an number?
  def self.a_number?(s)
    s.to_s.match(%r{\A[+-]?\d+?(\.\d+)?\Z}).nil? ? false : true
  end
end
