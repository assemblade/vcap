#
# Cookbook Name:: uaa
# Recipe:: default
#
# Copyright 2011, VMWARE
#
#


cf_pg_reset_user_password(:uaadb)
cf_pg_reset_user_password(:ccdb)


template "uaa" do
  path File.join("", "etc", "init.d", "uaa")
  source "uaa.erb"
  owner node[:deployment][:user]
  mode 0755
end

template "uaa.yml" do
  path File.join(node[:deployment][:config_path], "uaa.yml")
  source "uaa.yml.erb"
  owner node[:deployment][:user]
  mode 0644
end

#directory "#{node[:cloudfoundry][:path]}/uaa" do
#  owner "root"
#  group "root"
#  mode "0755"
#  recursive true
#  action :create
#end


bash "Git clone UAA" do
  user node[:deployment][:user]
  not_if {File.exists?("#{node[:cloudfoundry][:path]}/uaa")}
  code <<-EOH
    cd #{node[:cloudfoundry][:path]};
    git clone https://github.com/cloudfoundry/uaa.git
  EOH
end


bash "Build and Deploy UAA" do
  user node[:deployment][:user]
  code <<-EOH
    cd #{node[:cloudfoundry][:path]}/uaa;
    export JAVA_HOME=#{node[:java][:home]}
    #{node[:maven][:path]}/bin/mvn clean install -U -DskipTests=true;
    rm -Rf #{node[:tomcat][:base]}/webapps/ROOT;
    cp -f #{node[:cloudfoundry][:path]}/uaa/uaa/target/cloudfoundry-identity-uaa-*.war #{node[:tomcat][:base]}/webapps/ROOT.war
  EOH
end

cf_bundle_install(File.expand_path("uaa", node["cloudfoundry"]["path"]))

  
service "uaa" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
