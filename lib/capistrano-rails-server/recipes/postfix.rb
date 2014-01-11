@configuration.load do
  namespace :postfix do
    desc "Install postfix"
    task :install, roles: :mail do
      run "#{sudo} DEBIAN_FRONTEND=noninteractive apt-get -y install postfix"
    end
    after "deploy:install", "postfix:install"

    desc "Setup postfix configuration"
    task :setup, roles: :mail do
      set :hostname, find_servers_for_task(current_task).first.host
      template "postfix_main.erb", "/tmp/postfix_main_cf"
      run "#{sudo} mv /etc/postfix/main.cf /tmp/old_postfix_main_cf"
      run "#{sudo} mv /tmp/postfix_main_cf /etc/postfix/main.cf"
      run "#{sudo} /etc/init.d/postfix reload"
    end
    after "postfix:install", "postfix:setup"

    desc "Show postfix stats"
    task :stats, roles: :mail do
      run "#{sudo} ls /var/spool/postfix/incoming|wc -l"
      run "#{sudo} ls /var/spool/postfix/active|wc -l"
      run "#{sudo} ls -R /var/spool/postfix/deferred|wc -l"
    end
  end
end