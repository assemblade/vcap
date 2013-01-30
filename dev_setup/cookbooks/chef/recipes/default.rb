bash "Re-install chef with this rvm ruby" do
  code <<-EOH
    if [ ! -e #{node[:chef][:ruby_gempath]}/#{node[:chef][:ruby_version]}/bin/chef-client ]
    then
      source /usr/local/rvm/scripts/rvm
      gem install chef
    fi
  EOH
end
