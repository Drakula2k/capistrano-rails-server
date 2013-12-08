@configuration.load do
  namespace :postfix do
    desc "Install postfix"
    task :install, roles: :mail do
      run "#{sudo} DEBIAN_FRONTEND=noninteractive apt-get -y install postfix"
    end
    after "deploy:install", "postfix:install"

    desc "Show postfix stats"
    task :stats, roles: :mail do
      run "#{sudo} ls /var/spool/postfix/incoming|wc -l"
      run "#{sudo} ls /var/spool/postfix/active|wc -l"
      run "#{sudo} ls -R /var/spool/postfix/deferred|wc -l"
    end
  end
end