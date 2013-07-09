define :rbenv_user do
  bash "clone rbenv" do
    user params[:name]
    code "git clone git://github.com/sstephenson/rbenv.git /home/#{params[:name]}/.rbenv"
    not_if { File.exists?("/home/#{params[:name]}/.rbenv") }
  end

  execute "clone ruby_build" do
    user params[:name]
    command "git clone git://github.com/sstephenson/ruby-build.git /home/#{params[:name]}/.rbenv/plugins/ruby-build"
    not_if { File.exists?("/home/#{params[:name]}/.rbenv/plugins/ruby-build") }
  end

  execute "add rbenv to profile" do
    user params[:name]
    command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> /home/#{params[:name]}/.profile && echo 'eval \"$(rbenv init -)\"' >> /home/#{params[:name]}/.profile"
    not_if {File.readlines("/home/#{params[:name]}/.profile").grep(/rbenv/).any? }
  end

  execute "add rbenv to bashrc" do
    user params[:name]
    command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"\neval \"$(rbenv init -)\"' >> /home/#{params[:name]}/tmp && cat /home/#{params[:name]}/.bashrc >> /home/#{params[:name]}/tmp && mv /home/#{params[:name]}/tmp /home/#{params[:name]}/.bashrc"
    not_if "cat /home/#{params[:name]}/.bashrc | grep rbenv"
  end

  execute "add rbenv to bash_profile" do
    user params[:name]
    command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> /home/#{params[:name]}/.bash_profile && echo 'eval \"$(rbenv init -)\"' >> /home/#{params[:name]}/.bash_profile"
    not_if "cat /home/#{params[:name]}/.bash_profile | grep rbenv"
  end
end