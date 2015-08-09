name              "ruby"
maintainer        "Martin Fenner"
maintainer_email  "martin.fenner@datacite.org"
license           "Apache 2.0"
description       "Installs Ruby using the Brightbox Ruby PPA"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.7.4"

# opscode cookbooks
depends           "apt"

%w{ ubuntu }.each do |platform|
  supports platform
end
