include_recipe 'apt'

rev = node.kernix[:revision]

if !node[:opsworks].nil? && node[:opsworks][:instance][:infrastructure_class] == 'ec2'
  myapp_deploy = false
  node[:deploy].each do |application, deploy|
    if deploy[:application] != node[:node][:name]
      Chef::Log.debug("Skipping kernix::deploy for application #{application} as it is not your app")
      next
    else
      Chef::Log.debug("Deploying #{application}")
      myapp_deploy = true
      rev = node.deploy.myapp.scm.revision
      if rev.nil?
        rev = "master"
      end
      Chef::Log.info("Deploying version #{rev}")
    end
    # include_recipe 'deploy'
    # opsworks_deploy_dir do
    #   user node[:deploy][:kernix][:user]
    #   group node[:deploy][:kernix][:group]
    #   path node[:deploy][:kernix][:deploy_to]
    # end
    # opsworks_deploy do
    #   deploy_data node[:deploy][:kernix]
    #   app :kernix
    # end
  end
  return if myapp_deploy == false
end

directory "/tmp/private_code/.ssh" do
  owner 'www-data'
  recursive true
end

#cookbook_file "/tmp/private_code/wrap-ssh4git.sh" do
#  source "wrap-ssh4git.sh"
#  owner 'www-data'
#  mode '0700'
#end

bash "create wrap ssh for git" do
  user "root"
  cwd "/"
  code <<-EOH
   echo '#!/usr/bin/env bash' > /tmp/private_code/wrap-ssh4git.sh
   echo '/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/tmp/private_code/.ssh/id_deploy" $1 $2' >> /tmp/private_code/wrap-ssh4git.sh
   chown www-data:www-data /tmp/private_code/wrap-ssh4git.sh
   chmod +x /tmp/private_code/wrap-ssh4git.sh
  EOH
end
#/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/home/vagrant/.ssh/id_rsa" $1 $2

cookbook_file "/tmp/private_code/.ssh/id_deploy" do
  source "id_deploy"
  owner 'www-data'
  mode '0700'
end

directory "/srv/www/kernix" do
  owner 'www-data'
  recursive true
end

# package git

deploy "/srv/www/kernix" do
  repo "git@bitbucket.org:selectionnist/kernix-fo-bo-mo.git"
  revision rev
  #"release"  or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user "www-data"
  enable_submodules true
  # symlinks({})
  # purge_before_symlink %w{/var/web/stt/etc}
  # create_dirs_before_symlink []
  # symlinks    "/var/web/stt/etc"   => "etc"
  symlink_before_migrate.clear
  create_dirs_before_symlink   %w(pub pub/tmp usr)
  purge_before_symlink         %w(etc/platform.conf.inc etc/app/stt.conf.inc etc/app/middle.conf.inc doc/init.php)
  symlinks                     "log" => "var/log",
                               "run" => "var/run",
                               "session" => "var/session",
                               "cache" => "var/cache",
                               "config/platform.conf.inc" => "etc/platform.conf.inc",
                               "config/stt.conf.inc" => "etc/app/stt.conf.inc",
                               "config/middle.conf.inc" => "etc/app/middle.conf.inc",
                               "config/doc.init.php" => "doc/init.php"
  #migrate true
  #migration_command "rake db:migrate"
  #environment "RAILS_ENV" => "production", "OTHER_ENV" => "foo"
  #shallow_clone true
  keep_releases 10
  action :deploy # or :rollback
  #restart_command "touch tmp/restart.txt"
  git_ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
end

directory "/srv/www/kernix/shared/config" do
  owner 'www-data'
  recursive true
end
