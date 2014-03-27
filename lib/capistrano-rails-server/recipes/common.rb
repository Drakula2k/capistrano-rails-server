def template(from, to)
  if templates[from]
    file = templates[from]
  else
    file = File.expand_path("../templates/#{from}", __FILE__)
  end

  erb = File.read(file)
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
