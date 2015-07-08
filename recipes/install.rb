bash "npm install2" do
  user "root"
  cwd "/srv/www/nodejs_backend/current"
  code <<-EOH
  npm install
  EOH
end
