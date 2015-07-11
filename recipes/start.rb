bash "npm packages install" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm install -g node-gyp
  npm install
  EOH
end


bash "npm start" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  PORT=#{node[:nodejs][:port]} node server.js &
  EOH
end
