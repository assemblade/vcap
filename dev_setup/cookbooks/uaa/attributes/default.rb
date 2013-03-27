include_attribute "uaadb"
include_attribute "tomcat"
include_attribute "maven"

default[:uaadb][:host] = "localhost"

default[:uaa][:jwt_secret] = "uaa_jwt_secret"

default[:uaa][:batch][:username] = "batch_user"
default[:uaa][:batch][:password] = "batch_password"

# uaa client registration bootstrap
default[:uaa][:admin][:password] = "adminsecret"
default[:uaa][:cloud_controller][:password] = "cloudcontrollersecret"
