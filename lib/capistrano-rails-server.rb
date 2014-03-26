require 'capistrano-rails-server/recipes/common'

@configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

@configuration.load do
  set_default(:capistrano_rails_server, [:base, :nginx, :passenger, :postgresql, :postfix, :rvm, :check, :key])
  set_default(:system_codename, "precise")

  capistrano_rails_server.each do |recipe|
    require "capistrano-rails-server/recipes/#{recipe}"
  end

end