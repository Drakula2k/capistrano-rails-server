#capistrano-rails-server gem#

Capistrano-rails-server is a collection of capistrano recipes for setting up production server for RoR. The current testing environment is Ubuntu 12.04 LTS.

Components: RVM, Nginx, Passenger, Postgresql, Postfix

## Installation ##
Add this line to your application's Gemfile:

    gem 'capistrano-rails-server', :require => false
    
And then execute:

    $ bundle install
    
## Using ##

### Configure your app ###
Run `$ cap init` in your app folder if you don't have deploy.rb in your config dir (details [here](http://www.capistranorb.com/documentation/getting-started/preparing-your-application/)).

Then include these lines to the end of your `deploy.rb`:

```ruby
# uncomment this if you need non en-US locale for postgresql server
#set :postgresql_locale, "ru_RU"
#set :postgresql_rebuild, true

# uncomment this if you need another version of Ruby
#set_default :rvm_ruby_string, "2.0.0-p353"
# 
# see other available params in documentation 
# https://github.com/Drakula2k/capistrano-rails-server


# you can remove any recipe if you don't need it
set :capistrano_rails_server, [:base, :nginx, :passenger, :postgresql, :postfix, :rvm, :check, :key]
require 'capistrano-rails-server'

```
### Prepare server (instructions for Ubuntu 12.04) ###

Create admin group:

    # addgroup admin

Create user for deployment:

    # adduser yourappuser --ingroup admin
    
(Optional) Edit `/etc/sudoers` file if you don't want to enter user's password several time during recipes running (don't forget to undo it after installing!):

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

`rvm_wrap:install`

`nginx:install`

`nginx:setup`

`nginx:start`

`nginx:stop`

`nginx:restart`

`passenger:setup`

`nginx:start`

`nginx:stop`

`passenger:restart`

`postgresql:install`

`postgresql:setup`

`postgresql:create_database`

`postgresql:rebuild` - rebuild Postgresql cluster with given locale and encoding. WARNING! This task removes all existing databases.

`key:generate`

`key:show` - show generated deployment key.

`key:remove`

`postfix:install`

`postfix:stats` - show postfix stats

### Available options and defaults for all recipes###
You can overwrite any of these options in `deploy.rb` file.

#### :rvm ####

`rvm_ruby_string` ("2.0.0-p353")

#### :postgresql ####

`postgresql_host` ("localhost")

`postgresql_user` (application)

`postgresql_password` (console password_prompt)

`postgresql_database` ("#{application}_production")

`postgresql_rebuild` (false)

`postgresql_encoding` ("UTF-8") - useful only if postgresql_rebuild is true

`postgresql_locale` ("en_US") - useful only if postgresql_rebuild is true

#### :passenger ####

`passenger_user` (user)

`passenger_env` ("production") - production or development
