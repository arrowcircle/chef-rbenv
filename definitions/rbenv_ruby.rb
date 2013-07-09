define :rbenv_ruby do
  # log "Installing ruby #{params[:name]} for user #{user}"
  user = params[:user]
  ruby_version = params[:name]
  app_name = params[:app_name]

  execute "Installing ruby #{ruby_version} for user #{user}" do
    command "sudo -u #{user} -H bash -l -c \"export PATH=\"/home/#{user}/.rbenv/bin:/home/#{user}/.rbenv/shims:$PATH\" && eval \"$(rbenv init -)\" && rbenv install #{ruby_version} && rbenv rehash && cd /home/#{user}/projects/#{app_name} && rbenv local #{ruby_version} && gem install bundler\""
    not_if { File.exists?("/home/#{user}/.rbenv/versions/#{ruby_version}") }
  end  
end
