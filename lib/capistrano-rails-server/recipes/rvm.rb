require 'rvm/capistrano'

@configuration.load do
  set_default :rvm_ruby_string, "2.0.0-p353"
  set_default :rvm_autolibs_flag, :enable
  set_default :use_sudo, true

  namespace :rvm_wrap do
    desc "Set default shell when rvm isn't installed yet"
    task :set_default_shell do
      set :default_shell, "sh"
    end
    before "deploy:ssh", "rvm_wrap:set_default_shell"

    desc "Install RVM and Ruby"
    task :install do
      run "/bin/bash --login -c 'rvm use #{rvm_ruby_string} --default'"
      run "/bin/bash --login -c 'rvm wrapper #{rvm_ruby_string} #{application} ruby'"
      run "/bin/bash --login -c 'rvm wrapper #{rvm_ruby_string} #{application} bundle'"
    end
    before "rvm_wrap:install", "rvm:install_rvm"
    before "rvm_wrap:install", "rvm:install_ruby"
    after "deploy:install", "rvm_wrap:install"
  end
end
