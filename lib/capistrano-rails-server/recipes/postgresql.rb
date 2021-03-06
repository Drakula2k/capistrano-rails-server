@configuration.load do
  set_default(:postgresql_host, "localhost")
  set_default(:postgresql_user) { application }
  set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
  set_default(:postgresql_database) { "#{application}_production" }
  set_default(:postgresql_rebuild, false)
  set_default(:postgresql_encoding, "UTF-8")
  set_default(:postgresql_locale, "en_US")

  namespace :postgresql do
    desc "Install the latest stable release of PostgreSQL"
    task :install, roles: :db, only: {primary: true} do
      run "#{sudo} add-apt-repository -y 'deb http://apt.postgresql.org/pub/repos/apt/ #{system_codename}-pgdg main'"
      run "#{sudo} wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | #{sudo} apt-key add -"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install postgresql-9.3 pgadmin3 libpq-dev"
    end
    after "deploy:install", "postgresql:install"

    desc "Setup PostgreSQL configuration"
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
      template "postgresql.conf.erb", "/tmp/postgresql_conf"
      run "#{sudo} mv /tmp/postgresql_conf /etc/postgresql/9.3/main/postgresql.conf"
    end
    after "deploy:setup", "postgresql:setup"
    after "postgresql:setup", "postgresql:restart"

    desc "Create a database for this application"
    task :create_database, roles: :db, only: {primary: true} do
      run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
      run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end
    after "postgresql:setup", "postgresql:create_database"

    desc "Symlink the database.yml file into latest release"
    task :symlink, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
    after "deploy:finalize_update", "postgresql:symlink"

    %w[start stop restart reload force-reload status].each do |command|
      desc "#{command} PostgreSQL"
      task command, roles: :db, only: {primary: true} do
        run "#{sudo} service postgresql #{command}"
      end
    end

    desc "Rebuild cluster with another encoding and locale. WARNING! This task will remove all databases."
    task :rebuild, roles: :db, only: {primary: true} do
      answer = 
      Capistrano::CLI.ui.ask "This task will remove all existing DBs, run it only on fresh server installation!
Do you want to run this task? Otherwise this task will be skipped. (y/n):"
      if %w(Y y yes).include? answer
        run "#{sudo} locale-gen #{postgresql_locale}.#{postgresql_encoding}"
        run "#{sudo} service postgresql stop"
        run "#{sudo} pg_dropcluster --stop 9.3 main"
        run "#{sudo} pg_createcluster --start --locale #{postgresql_locale}.#{postgresql_encoding} -e #{postgresql_encoding} 9.3 main"
      else
        Capistrano::CLI.ui.say "postgresql:rebuild task skipped."
      end

    end
    if postgresql_rebuild
      before "postgresql:setup", "postgresql:rebuild"
    end

    desc "Export and download database to tmp dir"
    task :export, roles: :db, only: {primary: true} do
      run "pg_dump #{postgresql_database} > /tmp/#{postgresql_database}.sql", :shell => "sh"
      download "/tmp/#{postgresql_database}.sql", "tmp/#{postgresql_database}.sql"
    end

    desc "Upload and import database from tmp dir"
    task :import, roles: :db, only: {primary: true} do
      upload "tmp/#{postgresql_database}.sql", "/tmp/#{postgresql_database}.sql"
      answer = Capistrano::CLI.ui.ask "Are you sure want to import DB on this server?"
      if %w(Y y yes).include? answer
        run "psql #{postgresql_database} < /tmp/#{postgresql_database}.sql"
      else
        Capistrano::CLI.ui.say "postgresql:import task skipped."
      end
    end
  end
end