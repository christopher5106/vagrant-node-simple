include_recipe 'apt'

directory "/tmp/private_code/.ssh" do
  owner 'www-data'
  recursive true
end

bash "create wrap ssh for git" do
  user "root"
  cwd "/"
  code <<-EOH
   mkdir -p /var/www/.ssh
   chown www-data:www-data /var/www
   chown www-data:www-data /var/www/.ssh
   cp /vagrant/deploy.pem /var/www/.ssh/
   chown www-data:www-data /var/www/.ssh/deploy.pem
   chown 600 /var/www/.ssh/deploy.pem
   echo '#!/usr/bin/env bash' > /tmp/private_code/wrap-ssh4git.sh
   echo '/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/var/www/.ssh/deploy.pem" $1 $2' >> /tmp/private_code/wrap-ssh4git.sh
   chown www-data:www-data /tmp/private_code/wrap-ssh4git.sh
   chmod +x /tmp/private_code/wrap-ssh4git.sh
  EOH
end

directory "/srv/www/#{node[:nodejs][:name]}" do
  owner 'www-data'
  recursive true
end

deploy "/srv/www/#{node[:nodejs][:name]}" do
  repo node[:nodejs][:repo]
  revision node[:nodejs][:revision]
  user "www-data"
  enable_submodules true
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  keep_releases 10
  action :deploy # or :rollback
  git_ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
end
