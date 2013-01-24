#
# Cookbook Name:: router
# Recipe:: default
#
# Copyright 2011, VMware
#


bash "git clone router" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/router ]
    then
      cd #{node[:cloudfoundry][:home]}
      git clone https://github.com/hayatoshimizuBSKYB/router.git
    fi
  EOH
end

<<<<<<< HEAD
cf_bundle_install(File.expand_path("router", node[:cloudfoundry][:home]))

template "router" do
  path File.join("", "etc", "init.d", "router")
  source "router.erb"
  owner node[:deployment][:user]
  mode 0755
end
      
service "router" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template node[:router][:config_file] do
   path File.join(node[:deployment][:config_path], node[:router][:config_file])
   source "router.yml.erb"
   owner node[:deployment][:user]
   mode 0644
  notifies :restart, "service[router]"
end

=======
cf_bundle_install(File.expand_path("router", node[:cloudfoundry][:path]))
>>>>>>> c836723d9dd16d61929b7603f5b924a6d98af021
