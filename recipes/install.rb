bash "npm packages install" do
  user "root"
  cwd "/home/ubuntu/"
  code <<-EOH
    curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
  EOH
end
