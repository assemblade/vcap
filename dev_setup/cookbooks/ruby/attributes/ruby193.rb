include_attribute "deployment"

default[:ruby193][:version] = "1.9.3-p194"
default[:ruby193][:id] = "eyJvaWQiOiI0ZTRlNzhiY2EzMWUxMjEyMDRlNGU4NmVlMzk2OTIwNTA3NWUx%0AMjdhZGIwMSIsInNpZyI6InY5d0FVYnZsNzFONStnU2Z3NUN6YVVWNFNHWT0i%0AfQ==%0A"

default[:ruby193][:path]    = File.join(node[:deployment][:home], "deploy", "rubies", "ruby-#{ruby193[:version]}")
default[:ruby][:checksums]["1.9.3-p194"] = "46e2fa80be7efed51bd9cdc529d1fe22ebc7567ee0f91db4ab855438cf4bd8bb"

default[:rubygems][:version] = "1.8.24"
default[:rubygems][:id] = "eyJzaWciOiJIUk51OEJpN2pkdTVDTmVKUTlZZ1N5NGxraHc9Iiwib2lkIjoi%0ANGU0ZTc4YmNhMzFlMTIxMDA0ZTRlN2Q1MTQ3NDVmMDUwMTlmMzU5MmU4ZDki%0AfQ==%0A"
default[:rubygems][:checksum] = "4b61fa51869b3027bcfe67184b42d2e8c23fa6ab17d47c5c438484b9be2821dd"
default[:ruby][:bundler][:version] = "1.2.1"
