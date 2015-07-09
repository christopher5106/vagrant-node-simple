bash "npm packages install" do
  user "www-data"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm install
  EOH
end


bash "npm start" do
  user "www-data"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm start
  EOH
end
