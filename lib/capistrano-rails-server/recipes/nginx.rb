@configuration.load do
  namespace :nginx do
    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      template "nginx_passenger.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /opt/nginx/conf/nginx.conf"
      template "nginx_init.erb", "/tmp/nginx_init"
      run "chmod +x /tmp/nginx_init"
      run "#{sudo} update-rc.d -f nginx remove"
      run "#{sudo} mv /tmp/nginx_init /etc/init.d/nginx"
      run "#{sudo} update-rc.d -f nginx defaults"
    end
    after "deploy:setup", "nginx:setup"
    after "nginx:setup", "nginx:start"

    %w[start stop].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
      after "deploy:#{command}", "nginx:#{command}"
    end
  end
end