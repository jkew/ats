# Version of traffic server; as used in the default
# recipe. If you just want to use whatever version
# your distro has, make sure to remove the version
# specifier in default.rb
default[:ats][:version]="3.2.0"
default[:ats][:install_root] = "/opt/trafficserver"
default[:ats][:cache_size] = "256M"
default[:ats][:cache_dir] = "/data/trafficserver"
default[:ats][:proxy_name] = "ATS"
default[:ats][:server_ports] = "8080 9443:ssl"
# These are the root paths to all ssl keys are certs used
# from the multicert_ssl.config file
default[:ats][:cert_path] = "/path/to/ssl/certs"
default[:ats][:private_key_path] = "/path/to/ssl/keys"
default[:ats][:ca_cert_path] = "/path/to/ssl/ca_certs"
# Cache all responses with cookies; see records.config
default[:ats][:cache_cookies_mode] = "1"
default[:ats][:remap] = ["https://www.example.com:443"]
default[:ats][:origin] = "https://origin.example.com:443"
default[:ats][:ssl_hosts] = ["www.example.com"]
