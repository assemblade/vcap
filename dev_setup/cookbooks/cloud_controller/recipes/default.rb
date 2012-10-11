#
# Cookbook Name:: cloud_controller
# Recipe:: default
#
# Copyright 2011, VMware
#
#

include_recipe "deployment"
include_recipe "uaa"
include_recipe "service_broker"
include_recipe "python"
include_recipe "erlang"

template node[:cloud_controller][:config_file] do
  path File.join(node[:deployment][:config_path], node[:cloud_controller][:config_file])
  source "cloud_controller.yml.erb"
  owner node[:deployment][:user]
  mode 0644

  builtin_services = []
  case node[:cloud_controller][:builtin_services]
  when Array
    builtin_services = node[:cloud_controller][:builtin_services]
  when Hash
    builtin_services = node[:cloud_controller][:builtin_services].keys
  when String
    builtin_services = node[:cloud_controller][:builtin_services].split(" ")
  else
    Chef::Log.info("Input error: Please specify cloud_controller builtin_services as a list, it has an unsupported type #{node[:cloud_controller][:builtin_services].class}")
    exit 1
  end
  variables({
    :builtin_services => builtin_services
  })
end

template node[:cloud_controller][:runtimes_file] do
   path File.join(node[:deployment][:config_path], node[:cloud_controller][:runtimes_file])
   source "runtimes.yml.erb"
   owner node[:deployment][:user]
   mode 0644
end


bash "Git Clone cloud_controller" do
  cwd "#{node[:cloudfoundry][:home]}"
  code <<-EOH
    [ -e #{node[:cloudfoundry][:home]}/cloud_controller ] || git clone https://github.com/cloudfoundry/cloud_controller.git
  EOH
end


cf_bundle_install(File.expand_path(File.join("cloud_controller", "cloud_controller"), node[:cloudfoundry][:home]))

cf_pg_reset_user_password(:ccdb)


template "vcap_redis.conf" do
  path File.join(node[:deployment][:config_path], "vcap_redis.conf")
  source "vcap_redis.conf.erb"
  owner node[:deployment][:user]
  mode 0644
end

template "vcap_redis" do
  path File.join("", "etc", "init.d", "vcap_redis")
  source "vcap_redis.erb"
  owner node[:deployment][:user]
  mode 0755
end

service "vcap_redis" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :restart ]
end

staging_dir = File.join(node[:deployment][:config_path], "staging")
node[:cloud_controller][:staging].each_pair do |framework, config|
  template config do
    path File.join(staging_dir, config)
    source "#{config}.erb"
    owner node[:deployment][:user]
    mode 0644
  end
end
