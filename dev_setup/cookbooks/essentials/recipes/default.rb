#
# Cookbook Name:: essentials
# Recipe:: default
#
# Copyright 2011, VMWARE
#
#


%w{apt-utils build-essential libssl-dev libssl0.9.8 libreadline-dev libreadline6-dev libncurses5-dev
   libxml2 libxml2-dev libxslt1.1 libxslt1-dev git-core sqlite3 libsqlite3-ruby
   libsqlite3-dev unzip zip ruby-dev libmysql-ruby libmysqlclient-dev libcurl4-openssl-dev libpq5 libpq5-dev}.each do |p|
  package p do
    action [:install]
  end
end


directory "#{node[:deployment][:setup_cache]}" do
  action :create
end
