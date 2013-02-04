default[:dea][:config_file] = "dea.yml"
default[:dea][:local_route] = nil
default[:dea][:runtimes] = ["ruby18", "ruby193", "node08", "java", "java7", "erlang", "php", "python2"]
default[:dea][:logging] = 'debug'
default[:dea][:secure] = false
default[:dea][:multi_tenant] = true
default[:dea][:enforce_ulimit] = false
default[:dea][:base_dir] = "/var/vcap.local/dea"
