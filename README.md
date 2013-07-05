#capistrano-rails-server gem#

Capistrano-rails-server is collection of capistrano recipes for setting up production server for ROR. The current testing environment is Ubuntu 12.04LTS.
## Installation ##
Add these lines to your application's Gemfile:

    gem 'capistrano'
    gem 'capistrano-rails-server'
    gem 'unicorn'
    
And then execute:

    $ bundle install
    
## Using ##

### Prepare your app ###
Run `$ cap init` in your app folder (details [here](http://www.capistranorb.com/documentation/getting-started/preparing-your-application/)).

Than include recipes from this gem to your `deploy.conf`:

example `deploy.conf` file:

```ruby
require "bundler/capistrano"
load "deploy/assets"

# uncomment this if you need non en-US locale for postgresql server
#set :postgresql_locale, "ru_RU"
#set :postgresql_rebuild, true

# uncomment this if you need another version of ruby or using another OS
#set_default :ruby_version, "2.0.0-p247"
#set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

set :application, "yourappuser"

server "yourapp.address", :app, :web, :db, :primary => true

set :user, "yourapp"
set :use_sudo, false
set :deploy_to, "/home/#{user}/apps/#{application}"
#set :deploy_via, :remote_cache
set :repository, "yourrepo"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy:update_code', 'deploy:migrate'
set :keep_releases, 5
after 'deploy', 'deploy:cleanup'

# you can comment out any recipe if you don't need it
require "capistrano-rails-server/recipes/base"
require "capistrano-rails-server/recipes/nginx"
require "capistrano-rails-server/recipes/unicorn"
require "capistrano-rails-server/recipes/postgresql"
require "capistrano-rails-server/recipes/rbenv"
require "capistrano-rails-server/recipes/check"
# uncomment this if you need to generate deployment ssh key for private repository
# public key will be printed at the end of deploy:install task
#require "capistrano-rails-server/recipes/key"

```
### Prepare server (instructions for Ubuntu 12.04) ###

Create admin group:

    # addgroup admin

Create user for deployment:

    # adduser yourappuser --ingroup admin
    
(Optional) Edit `/etc/sudoers` file if you don't want to enter user's password several time during recipes running:

replace line 

    %admin ALL=(ALL) ALL
    
with 

    %admin ALL=(ALL) NOPASSWD:ALL
    
### Deploying ###


After that run command to install all software needed: 

    $ cap deploy:install
    
And configure it:

    $ cap deploy:setup

    
Thats all, now you can deploy your app:

    $ cap deploy
    
## Options ##
### Available cap tasks ###
`deploy:install` - install all software.

`deploy:setup` - configure all software.

`rbenv:install`

`nginx:install`

`nginx:setup`

`nginx:start`

`nginx:stop`

`nginx:restart`

`unicorn:setup`

`unicorn:start`

`unicorn:stop`

`unicorn:restart`

`postgresql:install`

`postgresql:setup`

`postgresql:create_database`

`postgresql:rebuild` - rebuild Postgresql cluster with given locale and encoding. WARNING! This task removes all existing databases.

`key:generate`

`key:show` - show generated deployment key.

`key:remove`

### Available options and defaults ###
You can overwrite any of these options in `deploy.conf` file.

`ruby_version`

`rbenv_bootstrap`

`postgresql_host`

`postgresql_user`

`postgresql_password`

`postgresql_database`

`postgresql_rebuild`

`postgresql_encoding` - useful only if postgresql_rebuild is true

`postgresql_locale` - useful only if postgresql_rebuild is true

`unicorn_user`

`unicorn_pid`

`unicorn_config`

`unicorn_log`

`unicorn_workers`
