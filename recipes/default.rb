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

ats_version=node[:ats][:version]
artifact = "trafficserver-#{ats_version}.tar.bz2" 
ats_url = "#{node[:ats][:mirror]}/#{artifact}"
local_src = "#{node[:ats][:build_root]}/#{artifact}"
local_src_dir = "#{node[:ats][:build_root]}/trafficserver-#{ats_version}"
install_root = "/usr/local/trafficserver-#{ats_version}"

remote_file local_src do
  source ats_url
  checksum node[:ats][:sha256]
  action :nothing
end
 
http_request "ats" do
  url ats_url
  action :head
  if File.exists?(local_src)
    headers "If-Modified-Since" => File.mtime(local_src).httpdate
  end
  notifies :create, resources(:remote_file => local_src), :immediately
end

execute "tar" do
 user "root"
 group "root"
 cwd node[:ats][:build_root]
  command "tar jxf #{artifact}"
 creates local_src_dir
 action :run
end

script "install_trafficserver" do
  interpreter "bash"
  user "root"
  cwd local_src_dir
  code <<-EOH
  chmod 755 ./configure
  ./configure --prefix=#{install_root} --enable-experimental-plugins
  make
  make install
  ln -sf #{install_root} #{node[:ats][:link]}
  EOH
  not_if {File.exist?(install_root)}
end


#template "/etc/init.d/trafficserver" do
#  user "root"
#  group "root"
#  source "trafficserver-init.erb"
#  mode '0755'
#end

#template "/etc/default/trafficserver" do
#  user "root"
#  group "root"
#  source "trafficserver.erb"
#  mode '0644'
#end

#service "trafficserver" do
#  supports :status => true, :restart => true, :reload => true
#  action [:enable, :start]
#end
