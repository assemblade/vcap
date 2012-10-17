
log "Checking #{node[:ruby][:gempath]}/#{node[:ruby][:version]}/gems/blobstore_client-#{node[:blobstore_client][:blobstore_client_version]}"

bash "Install blobstore_client" do
  code <<-EOH
    if [ ! -e #{node[:ruby][:gempath]}/#{node[:ruby][:version]}/gems/blobstore_client-#{node[:blobstore_client][:blobstore_client_version]} ]
    then
      echo Installing
      source /usr/local/rvm/scripts/rvm
      gem install blobstore_client
    else
      echo blobstore_client already installed
    fi
  EOH
end