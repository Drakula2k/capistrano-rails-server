# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "capistrano-rails-server"
  s.version     = "1.2.0"
  s.date        = "2013-07-16"
  s.summary     = "Capistrano recipes to setup Rbenv, Nginx, Unicorn and Postgresql production environment."
  s.description =
  "That gem includes capistrano recipes to install and configure ROR production development with Rbenv, Nginx, Unicorn and Postgresql."
  s.authors     = ["Drakula2k"]
  s.email       = "drakula2k@gmail.com"
  s.homepage    = "https://github.com/Drakula2k/capistrano-rails-server"
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.add_dependency "capistrano", "~> 2.15.5"
  s.add_development_dependency "rake"

end