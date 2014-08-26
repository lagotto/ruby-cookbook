name              "rails"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Configure Rails applications"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.1"
depends           "apt", "2.3.8"
depends           "git", "4.0.0"
depends           "build-essential", "2.0.0"
depends           "database", "~> 2.3.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
