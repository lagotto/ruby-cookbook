# add PPA for Ruby 2.x
apt_repository 'brightbox-ruby-ng' do
  uri          'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution 'trusty'
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C3173AA6'
end

# install required packages
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

# create new database.yml unless it exists already
# set these passwords in config.json to keep them persistent
unless File.exists?("/var/www/#{node['rails']['name']}/shared/config/database.yml")
  node.set_unless['mysql']['server_root_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_repl_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_debian_password'] = SecureRandom.hex(8)
  database_exists = false
else
  database = YAML::load(IO.read("/var/www/#{node['rails']['name']}/shared/config/database.yml"))
  server_root_password = database[node['rails']['environment']]['password']

  node.set_unless['mysql']['server_root_password'] = server_root_password
  node.set_unless['mysql']['server_repl_password'] = server_root_password
  node.set_unless['mysql']['server_debian_password'] = server_root_password
  database_exists = true
end

template "/var/www/#{node['rails']['name']}/shared/config/database.yml" do
  source 'database.yml.erb'
  owner node['nginx']['user']
  group node['nginx']['group']
  mode 0644
end

include_recipe "mysql::server"
include_recipe "database::mysql"

# Create default MySQL database
mysql_database node['rails']['name'] + "_" + node['rails']['environment'] do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

# install nginx with passenger
include_recipe "nginx::default"
