#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, Your Company, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node["platform"]
when "debian","ubuntu"
 package "build-essential" do
   action :install
 end
when "redhat","centos","fedora"
 %w{make automake gcc gcc-c++ kernel-devel}.each do |pkgs|
    package pkgs do
     action :install
    end
  end
end

user node[:redis][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:redis][:dir] do
  owner "root"
  mode "0755"
  action :create
end

directory node[:redis][:data_dir] do
  owner "redis"
  mode "0755"
  action :create
end

directory node[:redis][:log_dir] do
  mode 0755
  owner node[:redis][:user]
  action :create
end

directory node[:redis][:pid_dir] do
  mode 0744
  owner node[:redis][:user]
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/redis.tar.gz" do
  source "http://download.redis.io/redis-stable.tar.gz"
  action :create_if_missing
end

bash "compile_redis_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
   tar xvzf redis.tar.gz
   cd redis-stable
   make && make install
  EOH
  creates "/usr/local/bin/redis-server"
end

case node["platform"]
 when "debian","ubuntu"
 service "redis" do
  provider Chef::Provider::Service::Init::Debian
  subscribes :restart, resources(:bash => "compile_redis_source")
  supports :restart => true, :start => true, :stop => true
 end
 when "redhat","centos","fedora"
 service "redis" do
  provider Chef::Provider::Service::Init::Redhat
  subscribes :start, resources(:bash => "compile_redis_source")
  supports :restart => true, :start => true, :stop => true
 end
end
  

template "redis.conf" do
  path "#{node[:redis][:dir]}/redis.conf"
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis")
end

case node["platform"]
 when "debian","ubuntu"
   template "redis.start.conf" do
   path "/etc/init.d/redis"
   source "redis.start.conf.erb"
   owner "root"
   group "root"
   mode "0755"
   notifies :restart, resources(:service => "redis")
   end
 when "redhat","centos","fedora"
   template "redis.rcf.start.conf" do
   path "/etc/init.d/redis"
   source "redis.rcf.start.conf"
   path "/etc/init.d/redis"
   source "redis.rcf.start.conf.erb"
   owner "root"
   group "root"
   mode "0755"
   notifies :restart, resources(:service => "redis")
   end
end

service "redis" do
  action [:enable, :start]
end
