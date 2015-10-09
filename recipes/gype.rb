bash "npm-gype-install" do
  user "root"
  cwd "/home/ubuntu"
  code <<-EOH
  npm install -g node-gyp
  echo "unsafe-perm = true" >> /home/ubuntu/.npmrc
  EOH
end
