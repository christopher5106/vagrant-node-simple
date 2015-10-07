bash "npm-gype-install" do
  user "root"
  cwd "/home/ubuntu"
  code <<-EOH
  apt-get -y install node-gyp
  echo "unsafe-perm = true" >> /home/ubuntu/.npmrc
  EOH
end
