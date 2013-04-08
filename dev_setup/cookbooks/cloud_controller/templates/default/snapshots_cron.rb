# Recipe: cassandra::snapshots_cron
include_recipe "cron"
require "digest/md5"

checksum   = Digest::MD5.hexdigest "#{node['fqdn'] or 'unknown-hostname'}"
sleep_time = checksum.to_s.hex % node[:cassandra][:splay].to_i
log_file   = node[:cloud_controller][:snapshot_log_file]


cron_d "cf-backup" do
  action :delete
end

cron_d "cf-backup" do
  minute 0
  hour 3
  command "rsync #{node[:cloud_controller][:data_path]} #{node[:cloud_controller][:backup_path]}"
  user "#{node[:vcap][:user]}"
end

