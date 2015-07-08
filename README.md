# Simple Chef Cookbook for NodeJS on Ubuntu 14.04

This recipe enables deploy of a NodeJS app on Opsworks and Vagrant.

Usage : create your git repository with a Berksfile, a environments directory, and a Vagrantfile.

In the Berksfile

    cookbook 'git'
    cookbook 'apt', git: 'git://github.com/opscode-cookbooks/apt.git'
    cookbook 'mysql-simple', git: 'git://github.com/christopher5106/node-simple.git'

In environments/development.rb :

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
        "name":"XXXXXXXXXXXXXX"
      }
    }
  }
```

where `name` is the name of your app.

In the Vagrantfile

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

Launch your instance with `vagrant up` command.

In Opsworks,
- create a stack with your git repository, berkshelf enabled, and the json :

```json
{
  "node_app":{
    "name":"XXXXXXXXXXXXXX"
  }
}
```

- create a layer and add the recipe "node-simple" to a layer

- create an app with name equals to the name of the app in the JSON.


Launch you instance in Opsworks.
