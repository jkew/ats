package "build-essential"
package "autoconf"
package "automake"
package "libtool"
package "g++"
package "libssl-dev"
package "tcl-dev"
package "expat"
package "libexpat-dev"
package "libpcre3-dev"
package "libcap-dev"

remote_directory "/usr/src/trafficserver-3.2.0" do
  source "trafficserver-3.2.0"
  files_owner "root"
  files_group "root"
end

script "install_trafficserver" do
  interpreter "bash"
  user "root"
  cwd "/usr/src/trafficserver-3.2.0"
  code <<-EOH
  chmod 755 ./configure
  ./configure --enable-layout=Apache
  make
  make install
  mkdir /usr/local/deflect
  cp -rp /usr/local/trafficserver /usr/local/deflect/trafficserver-app
  cd /usr/local/deflect
  cp -rp trafficserver-app/conf trafficserver-conf
  mkdir trafficserver-confstg
  EOH
  not_if {File.exist?("/usr/local/deflect/trafficserver-app") &&
          File.exist?("/usr/local/deflect/trafficserver-conf") &&
          File.exist?("/usr/local/deflect/trafficserver-confstg")}
end


template "/etc/init.d/trafficserver" do
  user "root"
  group "root"
  source "trafficserver-init.erb"
  mode '0755'
end

template "/etc/default/trafficserver" do
  user "root"
  group "root"
  source "trafficserver.erb"
  mode '0644'
end

service "trafficserver" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
