cf_ruby_install(node[:ruby192][:version], node[:ruby192][:id], node[:ruby192][:path], "gz")

# Rake 0.8.7 already installed by Ruby 1.9.2, so just install Bundler and upgrade rubygems
cf_rubygems_install(node[:ruby192][:path], node[:rubygems][:version], node[:rubygems][:id], node[:rubygems][:checksum])
cf_gem_install(node[:ruby192][:path], "bundler", node[:ruby][:bundler][:version])

%w[ rack eventmachine thin sinatra mysql pg vmc ].each {|gem| cf_gem_install(node[:ruby][:path], gem)}
