require 'securerandom'

default['ruby']['version'] = "2.1"
default['ruby']['install_dev_package'] = true
default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs }
default['ruby']['gems'] = %w{ bundler }

# default attributes for Rails applications
default['ruby']['user'] = 'vagrant'
default['ruby']['group'] = 'www-data'
default['ruby']['rails_env'] = "development"
default['ruby']['web'] = { 'default_server' => true }
default['ruby']['db'] = { 'username' => 'vagrant', 'password' => SecureRandom.hex(10), 'host' => 'localhost' }
