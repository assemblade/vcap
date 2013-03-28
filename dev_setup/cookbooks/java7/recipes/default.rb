#
# Cookbook Name:: java7
# Recipe:: default
#
# Copyright 2012, VMware
#
#

case node['platform']
when "ubuntu"
  %w{openjdk-7-jdk}.each do |pkg|
    package pkg
  end
else
  Chef::Log.error("Java 7 not supported on this platform.")
end
