maintainer       "VMware"
maintainer_email "support@vmware.com"
license          "Apache 2.0"
description      "Installs/Configures Tomcat"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ java }.each do |cb|
  depends cb
end

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end
