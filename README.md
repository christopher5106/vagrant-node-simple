# Simple Chef Cookbook for NodeJS on Ubuntu 14.04 for Vagrant [complementary to OpsWorks NodeJS cookbook]

This recipe enables deploy of a NodeJS app in your Vagrant box. This is complementary to [Opsworks NodeJS cookebook](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.10/opsworks_nodejs) (same parametrization.)

###Usage :

Create your Chef repository with a `Berksfile`, a `Vagrantfile` and `environments` and `roles` directories :

1. In the Berksfile

    cookbook 'ark'
    cookbook 'git'
    cookbook 'apt', git: 'git://github.com/opscode-cookbooks/apt.git'
    cookbook 'vagrant-node-simple', git: 'git://github.com/christopher5106/vagrant-node-simple.git'

2. In environments/development.rb :

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
      "nodejs":{
        "name":"YOUR_APP_NAME",
        "repo":"git@bitbucket.org:YOUR_ORG/YOUR_NODE_APP_REPO.git",
        "revision":"HEAD"
      }
    }
  }
```

3. In roles/nodejs_role.rb :

```ruby
name "my node app"
description "The base role"
run_list "recipe[git]","recipe[apt]","recipe[ark]","recipe[vagrant-node-simple::deploy]","recipe[vagrant-node-simple::install]","recipe[vagrant-node-simple:start]"
```

4. In the Vagrantfile

    VAGRANTFILE_API_VERSION = "2"

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      config.vm.box = "ubuntu/trusty64"
      config.vm.network "forwarded_port", guest: 3000, host: 3000
      config.berkshelf.enabled = true;
      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "./"
        chef.roles_path = "roles"
        chef.environments_path = "environments"
        chef.environment = "development"
        chef.add_role("nodejs_role")
      end
    end

5. Add your deploy key `deploy.pem` for your node app repository in your repository (`./deploy.pem`).

6. Commit your Chef repository.

You can Launch your instance with `vagrant up` command.

In Opsworks,

- create a stack with your Chef repository, Chef and Berkshelf enabled (no need for a custom JSON, everything will be in the app settings.)

- create a NodeJS layer (*you can also create a custom layer and add the recipe "opsworks_nodejs" to the setup step, the recipe "opsworks_nodejs::configure" to the configure step, and the recipe to "deploy::nodejs" to the deploy step*).

- create an app with the link to your YOUR_NODE_APP_REPO.

Launch your instance in Opsworks. Opsworks will deploy the code corresponding to the Branch/Revision specified in the app configuration, to the HEAD if not specified.

You can configure a hook in Github so that committed code will be [automatically deployed in Opsworks](http://bytes.babbel.com/en/articles/2014-01-22-github-service-hook-for-aws-ops-works.html).

Note : for your NodeJS app to work with Opsworks cookbook, you need a server.js file at the root of your YOUR_NODE_APP_REPO. [Link](http://docs.aws.amazon.com/opsworks/latest/userguide/workinglayers-node.html)
