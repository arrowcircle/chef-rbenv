%w{build-essential git-core bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev ssl-cert subversion libxslt-dev libxml2-dev git git-core}.each do |pkg|
  package pkg do
    action :install
  end
end