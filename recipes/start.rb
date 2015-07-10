bash "npm packages install" do
  user "www-data"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm install
  EOH
end


bash "npm start" do
  user "www-data"
  cwd "/srv/www/#{node[:nodejs][:name]}/current"
  code <<-EOH
  npm start
  EOH
end
