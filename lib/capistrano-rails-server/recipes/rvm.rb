require 'rvm/capistrano'

@configuration.load do
  set_default :rvm_ruby_string, "2.0.0-p353"
  set_default :rvm_autolibs_flag, :enable
  set_default :use_sudo, true

  desc "Install RVM and Ruby"
  namespace :rvm_wrap do
    task :install do
      run "/bin/bash --login -c 'rvm use #{rvm_ruby_string} --default'"
    end
  end
  before "rvm_wrap:install", "rvm:install_rvm"
  before "rvm_wrap:install", "rvm:install_ruby"
  after "deploy:install", "rvm_wrap:install"
end