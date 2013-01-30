maintainer       "VMware"
maintainer_email "support@vmware.com"
license          "Apache 2.0"
description      "Installs/Configures Ruby"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.0"

recipe           "ruby", "Ruby 1.9.2"
recipe           "ruby::ruby18", "Ruby 1.8"
recipe           "ruby::ruby193", "Ruby 1.9.3"
