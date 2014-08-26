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
