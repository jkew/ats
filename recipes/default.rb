package "trafficserver" do
  version node[:ats][:version]
  action :install
end

ats_config = %w(cache.config header_rewrite.config log_hosts.config logs_xml.config plugin.config prefetch.config records.config remap.config ssl_multicert.config storage.config update.config vaddrs.config)

ats_config.each do |tmpl|
    template "/opt/trafficserver/etc/trafficserver/#{tmpl}" do
      source "#{tmpl}.erb"
      owner "nobody"
      group "nogroup"
    end
end


directory node[:ats][:cache_dir] do
  owner "nobody"
  group "nogroup"
  mode 00755
  action :create
end

service "trafficserver" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
