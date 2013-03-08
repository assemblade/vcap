include_attribute "postgresql"
default[:health_manager][:config_file] = "health_manager.yml"
default[:health_manager][:database][:username] = node[:postgresql][:server_root_user]
default[:health_manager][:database][:password] = node[:postgresql][:server_root_password]
default[:health_manager][:local_route] = nil

default[:health_manager][:github_url] = "https://github.com/cloudfoundry/health_manager.git"
default[:health_manager][:logpath] = "/var/log/cloudfoundry/health_manager.log"