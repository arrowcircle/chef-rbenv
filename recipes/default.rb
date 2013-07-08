%w{build-essential git-core bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev ssl-cert subversion libxslt-dev libxml2-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/home/#{node['users']['user']}/.gemrc" do
  user node['users']['user']
  owner node['users']['user']
  source "gemrc.erb"
end

bash "clone rbenv" do
  user node['users']['user']
  code "git clone git://github.com/sstephenson/rbenv.git /home/#{node['users']['user']}/.rbenv"
  not_if { File.exists?("/home/#{node['users']['user']}/.rbenv") }
end

execute "clone ruby_build" do
  user node['users']['user']
  command "git clone git://github.com/sstephenson/ruby-build.git /home/#{node['users']['user']}/.rbenv/plugins/ruby-build"
  not_if { File.exists?("/home/#{node['users']['user']}/.rbenv/plugins/ruby-build") }
end

execute "add rbenv to profile" do
  user node['users']['user']
  command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> /home/#{node['users']['user']}/.profile && echo 'eval \"$(rbenv init -)\"' >> /home/#{node['users']['user']}/.profile"
  not_if "cat /home/#{node['users']['user']}/.profile | grep rbenv"
end

execute "add rbenv to bashrc" do
  user node['users']['user']
  command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> /home/#{node['users']['user']}/.bashrc && echo 'eval \"$(rbenv init -)\"' >> /home/#{node['users']['user']}/.bashrc"
  not_if "cat /home/#{node['users']['user']}/.bashrc | grep rbenv"
end

execute "add rbenv to bash_profile" do
  user node['users']['user']
  command "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> /home/#{node['users']['user']}/.bash_profile && echo 'eval \"$(rbenv init -)\"' >> /home/#{node['users']['user']}/.bash_profile"
  not_if "cat /home/#{node['users']['user']}/.bash_profile | grep rbenv"
end

execute "install ruby" do
  user node['users']['user']
  command "sudo -u #{node['users']['user']} -H bash -l -c \"rbenv install #{node['default_ruby_version']} && rbenv rehash && rbenv global #{node['default_ruby_version']} && rbenv rehash && gem install bundler\""
  not_if { File.exists?("/home/#{node['users']['user']}/.rbenv/versions/#{node['default_ruby_version']}") }
end