bash "npm packages install" do
  user "vagrant"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm install
  EOH
end


bash "npm start" do
  user "vagrant"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm start
  EOH
end
