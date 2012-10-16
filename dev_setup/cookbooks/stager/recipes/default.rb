#
# Cookbook Name:: stager
# Recipe:: default
#
# Copyright 2012, VMware
#

package "curl"

template node[:stager][:config_file] do
  path File.join(node[:deployment][:config_path], node[:stager][:config_file])
  source "stager.yml.erb"
  owner node[:deployment][:user]
  mode 0644
end

template node[:stager][:platform] do
  path File.join(node[:deployment][:config_path], node[:stager][:platform])
  source "platform.yml.erb"
  owner node[:deployment][:user]
  mode 0644
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


cf_bundle_install(File.expand_path("stager", node[:cloudfoundry][:home]))
