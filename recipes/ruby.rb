# install required packages
include_recipe 'build-essential::default'
include_recipe 'git::default'

case node['platform_version'].to_f
when 12.04 then distro = 'precise'
when 14.04 then distro = 'trusty'
end

# add PPA for Ruby 2.x
apt_repository 'brightbox-ruby-ng' do
  uri          'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution distro
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C3173AA6'
end

%w{libxml2-dev libxslt-dev ruby2.1 ruby2.1-dev curl}.each do |pkg|
  package pkg do
    action :install
  end
end

# install bundler
gem_package "bundler" do
  gem_binary "/usr/bin/gem"
end

# create shared folders using capistrano layout and set permissions
%w{ current shared/config shared/log shared/pids shared/system releases }.each do |dir|
  directory "/var/www/#{node['rails']['name']}/#{dir}" do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode 0755
    recursive true
    action :create
  end
end
