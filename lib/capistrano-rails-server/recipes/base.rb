@configuration.load do
  namespace :deploy do
    desc "Increase SSH timeouts for running long operations like Ruby compiling"
    task :ssh do
      cmd = %Q{grep -R "ClientAliveInterval" /etc/ssh/sshd_config}
      content = capture( %Q{bash -c '#{cmd}' || echo "false"}).strip
      if content == 'false'
        run %Q{#{sudo} bash -c "echo 'ClientAliveInterval 18' >> /etc/ssh/sshd_config"}
        run %Q{#{sudo} bash -c "echo 'ClientAliveCountMax 100' >> /etc/ssh/sshd_config"}
        run "#{sudo} service ssh restart"
      else
        run 'echo "sshd_config is already updated!"'
      end
    end
    before "deploy:install", "deploy:ssh"

    desc "Install everything onto the server"
    task :install do
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install python-software-properties software-properties-common git"
    end

    # Overwrite with no sudo
    desc <<-DESC
      Prepares one or more servers for deployment. Before you can use any \
      of the Capistrano deployment tasks with your project, you will need to \
      make sure all of your servers have been prepared with `cap deploy:setup'. When \
      you add a new server to your cluster, you can easily run the setup task \
      on just that server by specifying the HOSTS environment variable:

        $ cap HOSTS=new.server.com deploy:setup

      It is safe to run this task on servers that have already been set up; it \
      will not destroy any deployed revisions or data.
    DESC
    task :setup, :except => { :no_release => true } do
      dirs = [deploy_to, releases_path, shared_path]
      dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
      run "mkdir -p #{dirs.join(' ')}"
      run "chmod g+w #{dirs.join(' ')}" if fetch(:group_writable, true)
    end
  end
end