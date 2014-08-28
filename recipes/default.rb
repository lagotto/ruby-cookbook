# run apt-get update
include_recipe 'apt'

include_recipe 'build-essential'

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

%W{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs #{node['ruby']['version']} #{node['ruby']['version']}-dev curl }.each do |pkg|
  package pkg do
    action :install
  end
end

# install bundler, using the freshly installed Ruby
gem_package "bundler" do
  gem_binary "/usr/bin/gem"
end
