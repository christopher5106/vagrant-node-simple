# Simple Chef Cookbook for NodeJS on Ubuntu 14.04
Usage :

In my Berksfile

    cookbook 'git'
    cookbook 'apt', git: 'git://github.com/opscode-cookbooks/apt.git'
    cookbook 'mysql-simple', git: 'git://github.com/christopher5106/node-simple.git'

In environments/development.rb or in my OpsWorks Stack configuration :

```json
  {
    "name": "development",
    "description": "The master development branch",
    "cookbook_versions": {},
    "json_class": "Chef::Environment",
    "chef_type": "environment",
    "default_attributes": {},
    "override_attributes":
    {
      "environment":"development",
      "node_app":{
        "path":"XXXXXXXXXXXXXX"
      }
    }
  }
```

where `path` is the path to the app.

In my Vagrantfile

    VAGRANTFILE_API_VERSION = "2"

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      config.vm.box = "ubuntu/trusty64"
      config.vm.network "forwarded_port", guest: 3000, host: 3000
      config.berkshelf.enabled = true;
      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "./"
        chef.add_recipe "node-simple"
        chef.environments_path = "environments"
        chef.environment = "development"
      end
    end

In Opsworks, add the recipe "node-simple" to a layer.
