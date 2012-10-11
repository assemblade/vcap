


user "#{node['cfusers']['vcapuser']}" do
  comment "VCAP User"
  home "#{node['cfusers']['vcaphome']}"
  shell "/bin/bash"
end

