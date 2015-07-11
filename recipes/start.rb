bash "npm packages install" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm install -g node-gyp
  npm install
  npm install pm2 -g
  EOH
end


execute "npm start" do
  user "root"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  command "PORT=#{node[:nodejs][:port]} pm2 server.js"
  action :run
end
