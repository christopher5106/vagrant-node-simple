bash "npm packages install" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm install -g node-gyp
  npm install
  EOH
end


execute "npm start" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  command "PORT=#{node[:nodejs][:port]} node server.js &"
  action :run
end
