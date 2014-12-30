#
# Cookbook Name:: jenkins 
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

#include_recipe "tomcat"

tu=node[:tomcat][:user] 
tg=node[:tomcat][:group]
jbase=node[:tomcat][:jenkins_base]
jhome=node[:tomcat][:jenkins_home]
jxml=node[:tomcat][:jenkins_xml]

remote_file "#{node[:tomcat][:jenkins_war_path]}" do
  source "http://10.0.0.1/jenkins-stable.war"
  action :create
end

directory "jenkins base" do
   path "#{jbase}"
   owner "root"
   group "root"
   mode "0755"
   action :create
end

directory "jenkins home" do
   path "#{jhome}"
   owner "#{tu}"
   group "#{tg}"
   mode "0755"
   action :create
 end

service "tomcat" do
  provider Chef::Provider::Service::Init::Debian
  supports :restart => true, :start => true, :stop => true 
  #action [:enable, :start]
end

template "jenkins_xml" do
  path "#{jxml}"
  source "jenkins_xml.erb"
  owner "#{tu}"
  group "#{tg}"
  mode "0600"
  notifies :restart, resources(:service => "tomcat")
end
