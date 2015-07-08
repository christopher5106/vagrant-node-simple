bash "npm install3" do
  user "vagrant"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm start
  EOH
end
