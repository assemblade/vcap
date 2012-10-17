bash "Re-install chef with this rvm ruby" do
  code <<-EOH
    if [ ! -e #{node[:ruby][:gempath]}/#{node[:ruby][:version]}/bin/chef-client ]
    then
      source /usr/local/rvm/scripts/rvm
      gem install chef
    fi
  EOH
end
