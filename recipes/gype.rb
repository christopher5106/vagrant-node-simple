bash "npm packages install" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  apt-get -y install node-gyp
  echo "unsafe-perm = true" >> ~/.npmrc
  EOH
end
