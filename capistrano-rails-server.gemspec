# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "capistrano-rails-server"
  s.version     = "2.0.1"
  s.date        = "2014-03-03"
  s.summary     = "Capistrano recipes to setup RVM, Nginx, Unicorn, Postgresql and Postfix production environment."
  s.description =
  "That gem includes capistrano recipes to install and configure ROR production environment with RVM, Nginx, Unicorn, Postgresql and Postfix."
  s.authors     = ["Drakula2k"]
  s.email       = "drakula2k@gmail.com"
  s.homepage    = "https://github.com/Drakula2k/capistrano-rails-server"
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.add_dependency "capistrano", "~> 2.15"
  s.add_dependency "rvm-capistrano", "~> 1.5"
  s.add_development_dependency "rake"
end