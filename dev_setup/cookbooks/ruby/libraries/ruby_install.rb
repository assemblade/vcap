module RubyInstall
  def cf_ruby_install(ruby_version, ruby_source_id, ruby_path, ruby_tarball_suffix)

    Chef::Log.info "Installing ruby version: #{ruby_version}"
    
    %w[ build-essential libssl-dev zlib1g-dev libreadline6-dev libxml2-dev].each do |pkg|
      package pkg
    end

    ruby_tarball_path = File.join(node[:deployment][:setup_cache], "ruby-#{ruby_version}.tar.#{ruby_tarball_suffix}")
    remote_file ruby_tarball_path do
      source "#{node[:ruby][:download_url]}/ruby-#{ruby_version}.tar.bz2"
      mode 00644
      checksum node[:ruby][:checksums][ruby_version] # A SHA256 (or portion thereof) of the file.
    end

    directory ruby_path do
      owner node[:deployment][:user]
      group node[:deployment][:group]
      mode "0755"
      recursive true
      action :create
    end

    bash "Install Ruby #{ruby_path}" do
      cwd File.join("", "tmp")
      user node[:deployment][:user]
      code <<-EOH
        ruby_version=#{node[:ruby18][:version]}
        version_major=`echo $ruby_version | sed -e 's/-.*//g'`
        version_minor=`echo $ruby_version | sed -e 's/^[^-]*//g'` -e 's/p//g'`
        if [ `#{ruby_path}/bin/ruby -v | grep $version_major | grep $version_minor | wc -l` -gt 0 ]
        then
          # work around chef's decompression of source tarball before a more elegant
          # solution is found
          if [ "#{ruby_tarball_suffix}" = "bz2" ];then
            tar xf #{ruby_tarball_path}
          else
            tar xzf #{ruby_tarball_path}
          fi
          cd ruby-#{ruby_version}
          # See http://deadmemes.net/2011/10/28/rvm-install-fails-on-ubuntu-11-10/
          sed -i 's/\\(OSSL_SSL_METHOD_ENTRY(SSLv2[^3]\\)/\\/\\/\\1/g' ./ext/openssl/ossl_ssl.c
          ./configure --disable-pthread --prefix=#{ruby_path}
          make
          make install
        fi
      EOH
    end
  end

  def cf_rubygems_install(ruby_path, rubygems_version, rubygems_id, rubygems_checksum)
    
    rubygem_tarball_path = File.join(node[:deployment][:setup_cache], "rubygems-#{rubygems_version}.tgz")
      
    Chef::Log.info("Downloading #{node[:ruby][:download_url]}/rubygems-#{rubygems_version}.tgz to #{rubygem_tarball_path}")
    remote_file rubygem_tarball_path do
      source "#{node[:ruby][:download_url]}/rubygems-#{rubygems_version}.tgz"
      mode 00644
      checksum node[:ruby][:checksums][rubygems_version] # A SHA256 (or portion thereof) of the file.
    end

    bash "Install RubyGems #{ruby_path}" do
      cwd File.join("", "tmp")
      user node[:deployment][:user]
      code <<-EOH
      tar xzf #{rubygem_tarball_path}
      cd rubygems-#{rubygems_version}
      #{File.join(ruby_path, "bin", "ruby")} setup.rb
      EOH
    end
  end

  def cf_gem_install(ruby_path, gem_name, gem_version = nil)
    # The default chef installed with Ubuntu 10.04 does not support the "retries" option
    # for gem_package. It may be a good idea to add/use that option once the ubuntu
    # chef package gets updated.
    gem_package gem_name do
      version gem_version if !gem_version.nil?
      gem_binary File.join(ruby_path, "bin", "gem")
    end
  end
end

class Chef::Recipe
  include RubyInstall
end
