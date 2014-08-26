# install Ruby 2.1, required packages and bundler
include_recipe "rails::ruby"

# install and configure MySQL
include_recipe "rails::mysql"

# install nginx with passenger
include_recipe "rails::nginx"
