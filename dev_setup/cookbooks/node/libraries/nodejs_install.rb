module NodeInstall
  def cf_node_install(node_version, node_source_id, node_path, node_npm=nil)
    %w[ build-essential ].each do |pkg|
      package pkg
    end

    tarball_path = File.join(node[:deployment][:setup_cache], "node-v#{node_version}.tar.gz")
    
    remote_file tarball_path do
      source "#{node[:node][:download_url]}/node-v#{node_version}-linux-x64.tar.gz"
      mode 00644
      checksum node[:node][:checksums][node_version] # A SHA256 (or portion thereof) of the file.
    end

    node_path = "#{node[:deployment][:home]}/nodes"
    Chef::Log.info("Node install path: #{node_path}")

    directory node_path do
      owner node[:deployment][:user]
      group node[:deployment][:group]
      mode "0755"
      recursive true
      action :create
    end

    bash "Install Node.js version " + node_version do
      cwd node_path
      user node[:deployment][:user]
      code <<-EOH
      tar xzf #{tarball_path}
      cd node-v#{node_version}-linux-x64
      EOH
    end

    minimal_npm_bundled_node_version = "0.6.3"

    if Gem::Version.new(node_version) < Gem::Version.new(minimal_npm_bundled_node_version)

      npm_tarball_path = File.join(node[:deployment][:setup_cache], "npm-#{node_npm[:version]}.tgz")
      cf_remote_file npm_tarball_path do
        owner node[:deployment][:user]
        id node_npm[:id]
        checksum node_npm[:checksum]
      end

      directory node_npm[:path] do
        owner node[:deployment][:user]
        group node[:deployment][:group]
        mode "0755"
        recursive true
        action :create
      end

      bash "Install npm version " + node_npm[:version] do
        cwd File.join("", "tmp")
        user node[:deployment][:user]
        code <<-EOH
        tar xzf #{npm_tarball_path} --directory=#{node_npm[:path]} --strip-components=1
        EOH
      end
    end

  end
end

class Chef::Recipe
  include NodeInstall
end
