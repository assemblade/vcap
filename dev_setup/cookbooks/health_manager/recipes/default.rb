#
# Cookbook Name:: health_manager
# Recipe:: default
#
# Copyright 2011, VMware
#
template node[:health_manager][:config_file] do
  path File.join(node[:deployment][:config_path], node[:health_manager][:config_file])
  source "health_manager.yml.erb"
  owner node[:deployment][:user]
  mode 0644
end

template "health_manager" do
  path File.join("", "etc", "init.d", "health_manager")
  source "health_manager.erb"
  owner node[:deployment][:user]
  mode 0755
end


bash "git clone router" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/health_manager ]
    then
      cd #{node[:cloudfoundry][:home]}
      git clone https://github.com/cloudfoundry/health_manager.git
    fi
  EOH
end

cf_bundle_install(File.expand_path("health_manager", node[:cloudfoundry][:home]))

service "health_manager" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
