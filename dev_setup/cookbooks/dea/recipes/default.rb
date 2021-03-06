#
# Cookbook Name:: dea
# Recipe:: default
#
# Copyright 2011, VMWARE
#
#
%w{lsof psmisc librmagick-ruby}.each do |pkg|
  package pkg
end

node[:dea][:runtimes].each do |runtime|
  case runtime
  when "ruby19"
    include_recipe "ruby"
  when "ruby18"
    include_recipe "ruby::ruby18"
  when "ruby193"
    include_recipe "ruby::ruby193"
  when "node06"
    include_recipe "node::node06"
  when "node08"
    include_recipe "node::node08"
  when "node", "node04"
    include_recipe "node::node04"
  when "python2"
    include_recipe "python"
  else
    include_recipe "#{runtime}"
  end
end



template "dea" do
  path File.join("", "etc", "init.d", "dea")
  source "dea.erb"
  owner node[:deployment][:user]
  mode 0755
end

template "logrotate" do
  path File.join("", "etc", "logrotate.d", "dea")
  source "logrotate.erb"
  owner node[:deployment][:user]
  mode 0755
end


bash "git clone dea" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/dea ]
    then
      cd #{node[:cloudfoundry][:home]}
      git clone #{node[:cloudfoundry][:git_url]}/dea.git
    fi
  EOH
end

cf_bundle_install(File.join(node[:cloudfoundry][:path], "dea"))

  
service "dea" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
  
template node[:dea][:config_file] do
   path File.join(node[:deployment][:config_path], node[:dea][:config_file])
   source "dea.yml.erb"
   owner node[:deployment][:user]
   mode 0644
   notifies :restart, "service[dea]"
end
