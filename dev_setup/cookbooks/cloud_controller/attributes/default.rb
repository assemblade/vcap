include_attribute "deployment"
include_attribute "postgresql"
include_attribute "redis"
include_attribute "redis"
include_attribute "uaa"
include_attribute "service_lifecycle"
include_attribute "service_broker"
include_attribute "python"
include_attribute "erlang"
include_attribute "java7"
include_attribute "node::node04"
include_attribute "redis"


default[:deployment][:welcome] = "VMware's Cloud Application Platform"

default[:cloud_controller][:config_file] = "cloud_controller.yml"
default[:cloud_controller][:service_api_uri] = "http://api.#{node[:deployment][:domain]}"
default[:cloud_controller][:local_route] = nil
default[:cloud_controller][:admins] = ["dev@cloudfoundry.org"]
default[:cloud_controller][:runtimes_file] = "runtimes.yml"
default[:cloud_controller][:git_url] = "https://github.com/cloudfoundry/cloud_controller.git"

# Staging
default[:cloud_controller][:staging][:grails] = "grails.yml"
default[:cloud_controller][:staging][:lift] = "lift.yml"
default[:cloud_controller][:staging][:node] = "node.yml"
default[:cloud_controller][:staging][:otp_rebar] = "otp_rebar.yml"
default[:cloud_controller][:staging][:rack] = "rack.yml"
default[:cloud_controller][:staging][:rails3] = "rails3.yml"
default[:cloud_controller][:staging][:sinatra] = "sinatra.yml"
default[:cloud_controller][:staging][:spring] = "spring.yml"
default[:cloud_controller][:staging][:java_web] = "java_web.yml"
default[:cloud_controller][:staging][:php] = "php.yml"
default[:cloud_controller][:staging][:django] = "django.yml"
default[:cloud_controller][:staging][:wsgi] = "wsgi.yml"
default[:cloud_controller][:staging][:standalone] = "standalone.yml"
default[:cloud_controller][:staging][:play] = "play.yml"

# Default builtin services
default[:cloud_controller][:builtin_services] = ["redis", "mongodb", "mysql", "neo4j", "rabbitmq", "postgresql", "vblob", "memcached", "filesystem", "elasticsearch", "couchdb", "echo"]

# Default capacity
default[:capacity][:max_memory] = 2048
default[:capacity][:max_uris] = 4
default[:capacity][:max_services] = 16
default[:capacity][:max_apps] = 20

# Logging
default[:cloud_controller][:logpath] = "/var/log/cloudfoundry/cloud_controller.log"
  