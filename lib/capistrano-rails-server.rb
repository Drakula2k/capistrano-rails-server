require 'capistrano-rails-server/recipes/common'

@configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

@configuration.load do
  unless exists?(:capistrano_rails_server)
    set :capistrano_rails_server, [:base, :nginx, :passenger, :postgresql, :postfix, :rvm, :check, :key]
  end

  capistrano_rails_server.each do |recipe|
    require "capistrano-rails-server/recipes/#{recipe}"
  end

end