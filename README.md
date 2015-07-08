# Simple Chef Cookbook for NodeJS on Ubuntu 14.04 on Vagrant [complementary to Opworks NodeJS cookbook]

This recipe enables deploy of a NodeJS app on your Vagrant. This is complementary to [Opsworks NodeJS cookebook](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.10/opsworks_nodejs).

Usage : create your git repository with a Berksfile, a environments directory, and a Vagrantfile.

In the Berksfile

    cookbook 'git'
    cookbook 'apt', git: 'git://github.com/opscode-cookbooks/apt.git'
    cookbook 'vagrant-node-simple', git: 'git://github.com/christopher5106/node-simple.git'

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
      "node":{
        "name":"XXXXXXXXXXXXXX"
      }
    }
  }
```

where `name` is the name of your nodejs app (the same as in your Opsworks Apps).

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

- create a stack with your git repository, berkshelf enabled,

- create a NodeJS layer (you can also create a custom layer and add the recipe "opsworks_nodejs" to the setup step, the recipe "opsworks_nodejs::configure" to the configure step, and the recipe to "deploy::nodejs" to the deploy step)

- create an app with name equals to the name of the app in the JSON.

Launch your instance in Opsworks. Opsworks will deploy the code corresponding to the Branch/Revision specified in the app configuration, to the HEAD if not specified.

You can configure a hook in Github so that committed code will [automatically deployed in Opsworks](http://bytes.babbel.com/en/articles/2014-01-22-github-service-hook-for-aws-ops-works.html).
