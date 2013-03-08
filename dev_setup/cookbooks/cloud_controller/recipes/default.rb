#
# Cookbook Name:: cloud_controller
# Recipe:: default
#
# Copyright 2011, VMware
#
#


#bash "Install active reford" do
#  code <<-EOH
#    if [ ! -e #{node[:ruby][:gempath]}/#{node[:ruby][:version]}/gems/activerecord-#{node[:blobstore_client][:activerecord_version]} ]
#    then
#      echo Installing
#      source /usr/local/rvm/scripts/rvm
#      gem install blobstore_client
#    else
#      echo blobstore_client already installed
#    fi
#  EOH
#end

template "cloud_controller" do
  path File.join("", "etc", "init.d", "cloud_controller")
  source "cloud_controller.erb"
  owner node[:deployment][:user]
  mode 0755
end

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

template "logrotate" do
  path File.join("", "etc", "logrotate.d", "cloud_controller")
  source "logrotate.erb"
  owner node[:deployment][:user]
  mode 0755
end


bash "git clone cloud_controller" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/cloud_controller ]
    then
      cd #{node[:cloudfoundry][:home]}
      git clone #{node[:cloud_controller][:git_url]}
    fi
  EOH
end

cf_bundle_install(File.expand_path(File.join("cloud_controller", "cloud_controller"), node[:cloudfoundry][:path]))

cf_pg_reset_user_password(:ccdb)


bash "Initialise databse" do
  code <<-EOH
    if [ ! -e #{node[:cloudfoundry][:home]}/cloud_controller/.db_initialised ]
    then
      export CLOUD_CONTROLLER_CONFIG=#{node[:deployment][:config_path]}/cloud_controller.yml
      cd #{node[:cloudfoundry][:home]}/cloud_controller/cloud_controller
      rake db:migrate
      if [ $? == 0 ]
      then
        touch #{node[:cloudfoundry][:home]}/cloud_controller/.db_initialised
      fi
    fi
  EOH
end

directory "#{node[:cloudfoundry][:path]}/log" do
  owner "root"
  group "root"
  mode "0755"
  action :create
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


service "cloud_controller" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
