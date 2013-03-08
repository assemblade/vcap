#
# Cookbook Name:: stager
# Recipe:: default
#
# Copyright 2012, VMware
#

package "curl"

template node[:stager][:platform] do
  path File.join(node[:deployment][:config_path], node[:stager][:platform])
  source "platform.yml.erb"
  owner node[:deployment][:user]
  mode 0644
end


template "stager" do
  path File.join("", "etc", "init.d", "stager")
  source "stager.erb"
  owner node[:deployment][:user]
  mode 0755
end

template "logrotate" do
  path File.join("", "etc", "logrotate.d", "stager")
  source "logrotate.erb"
  owner node[:deployment][:user]
  mode 0755
end

bash "git clone stager" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/stager ]
    then
      cd #{node[:cloudfoundry][:home]}
      git clone https://github.com/cloudfoundry/stager.git
    fi
  EOH
end


cf_bundle_install(File.expand_path("stager", node[:cloudfoundry][:path]))

service "stager" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

  
template node[:stager][:config_file] do
  path File.join(node[:deployment][:config_path], node[:stager][:config_file])
  source "stager.yml.erb"
  owner node[:deployment][:user]
  mode 0644
  notifies :restart, "service[stager]"
end
