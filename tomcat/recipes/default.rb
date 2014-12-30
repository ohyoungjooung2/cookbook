#
# Cookbook Name:: tomcat
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
include_recipe "java"


user node[:tomcat][:user]do
  action :create
  system true
  shell "/bin/false"
end

group node[:tomcat][:group]do
  action :create
  system true
end
directory node[:tomcat][:dir] do
  owner node[:tomcat][:user]
  mode "0755"
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/tomcat.tar.gz" do
  source "http://10.0.0.1/apache-tomcat-8.0.15.tar.gz"
  action :create_if_missing
end

bash "install_tomcat8" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf /usr/local/tomcat/*
    tar xvzf tomcat.tar.gz
    mv apache-tomcat-8.0.15/* /usr/local/tomcat/
    chown -R cat:cat /usr/local/tomcat
   EOH
end

service "tomcat" do
  provider Chef::Provider::Service::Init::Debian
  subscribes :restart, resources(:bash => "install_tomcat8")
  supports :restart => true, :start => true, :stop => true 
end

template "tomcat_default" do
  path "/etc/default/tomcat8"
  source "tomcat8.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "tomcat")
end

template "tomcat8_start" do
  path "/etc/init.d/tomcat"
  source "tomcat8.start.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "tomcat")
end
#
#directory "make_policy_dir" do
#  path "/usr/local/tomcat/conf/policy.d"
#  action :create
#  owner "cat"
#  group "cat"
#  mode "644"
#end

service "tomcat" do
  provider Chef::Provider::Service::Init::Debian
  supports :restart => true, :start => true, :stop => true 
  action [:enable, :start]
end
