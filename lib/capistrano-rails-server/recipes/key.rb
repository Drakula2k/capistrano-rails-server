@configuration.load do
  namespace :key do
    desc "Generate deployment key for repository"
    task :generate, roles: :web do
      unless remote_file_exists?("~/.ssh/id_rsa")
        run %Q(ssh-keygen -q -N "" -t rsa -C #{user}@#{application} -f ~/.ssh/id_rsa)
        #run "ssh-add ~/.ssh/id_rsa"
      end
    end
    after "deploy:install", "key:generate"

    desc "Show public key"
    task :show, roles: :web do
      run "cat ~/.ssh/id_rsa.pub"
    end
    after "key:generate", "key:show"

    desc "Remove key from server"
    task :remove, roles: :web do
      run "rm -rf ~/.ssh/id_rsa"
      run "rm -rf ~/.ssh/id_rsa.pub"
    end
  end
end