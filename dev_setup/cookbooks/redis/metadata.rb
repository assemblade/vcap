maintainer       "VMware"
maintainer_email "support@vmware.com"
license          "Apache 2.0"
description      "Installs/Configures Redis"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.0"

depends "backup"
depends "service_lifecycle"
depends "deployment"
