require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proxy_host = ENV['proxy_host'] || ''
gem_proxy = ''
gem_proxy = "http_proxy=http://#{proxy_host}" unless proxy_host.empty?
if !proxy_host.empty?
  hosts.each do |host|
    case host['platform']
    when /ubuntu/, /debian/
      on host, "echo 'Acquire::http::Proxy \"http://#{proxy_host}/\";' >> /etc/apt/apt.conf.d/10proxy"
    when /^el-/, /centos/, /fedora/, /redhat/
      on host, "echo 'proxy=http://#{proxy_host}/' >> /etc/yum.conf"
      on host, "sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf"
      on host, "sed -i 's/mirrorlist.*/#/' /etc/yum.repos.d/*"
      on host, "sed -i 's/#baseurl/baseurl/' /etc/yum.repos.d/*"
    end
    on host, "echo 'export http_proxy=\"http://#{proxy_host}\"' >> /root/.bashrc"
    on host, "echo 'export https_proxy=\"http://#{proxy_host}\"' >> /root/.bashrc"
    on host, "echo 'export no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com,#{host.name}\"' >> /root/.bashrc"
  end
end

unless ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    # Install Puppet
    if host.is_pe?
      install_pe
    else 
      install_puppet
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'bamboo')
    hosts.each do |host|
      on host, puppet('module','install','mkrakowitzer-deploy'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','nanliu-staging'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
