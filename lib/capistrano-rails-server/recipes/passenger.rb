@configuration.load do
  set_default(:passenger_user) { user }
  set_default(:passenger_env, "production")

  namespace :passenger do
    desc "Install Passenger"
    task :install, roles: :app do
      run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7"
      run "#{sudo} apt-get -y install apt-transport-https ca-certificates ruby-dev rubygems rake"
      run "#{sudo} add-apt-repository -y https://oss-binaries.phusionpassenger.com/apt/passenger"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx-extras passenger libpcre3-dev libcurl4-openssl-dev zlib1g-dev bison libreadline-dev libncurses5-dev"
      run "#{sudo} passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --languages ruby"
    end
    after "deploy:install", "passenger:install"

    desc "Reload Passenger"
    task :restart, roles: :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
    after "deploy:restart", "passenger:restart"
  end
end
