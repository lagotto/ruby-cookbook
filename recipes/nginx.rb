case node['platform_version'].to_f
when 12.04 then distro = 'precise'
when 14.04 then distro = 'trusty'
end

# add PPA for nginx with passenger
apt_repository 'phusion-passenger' do
  uri          'https://oss-binaries.phusionpassenger.com/apt/passenger'
  distribution distro
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '561F9B9CAC40B2F7'
end

# install nginx with passenger
%w{ nginx-extras passenger }.each do |pkg|
  package pkg do
    options "-y"
    action :install
  end
end

# nginx configuration
template 'nginx.conf' do
  path   "#{node['nginx']['dir']}/nginx.conf"
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

# configuration for web app
# we use the conf.d folder rather than the sites-available folder
template 'web_app.conf' do
  path   "#{node['nginx']['dir']}/conf.d/#{node['rails']['name']}.conf"
  source 'web_app.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   :restart
end
