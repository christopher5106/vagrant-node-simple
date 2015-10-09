bash "npm packages install" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm install -g node-gyp
  npm install --unsafe-perm
  npm install pm2 -g
  EOH
end

execute "npm start" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  command "PORT=#{node[:nodejs][:port]} /usr/bin/pm2 start server.js"
  action :run
end
