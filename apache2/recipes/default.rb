#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2014, Your Company, Inc.
# For debian distros(mint,ubuntu,etc)
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
remote_file "/tmp/apache.tar.gz" do
  source "http://10.0.0.1/httpd-2.2.29.tar.gz"
  action :create
end

bash 'apache2_debian_sc' do
   user "root"
   cwd "/root"
   code <<-EOH
   check(){
    if [[ $? != "0" ]]
    then
      echo "Failed on $1"
      exit 1
    else
      echo "Success on $1"
    fi
   }

   rm_apache(){
     if [[  /usr/local/apache ]]
      then
       /usr/local/apache/bin/apachectl stop
       killall httpd
       sleep 3
       rm -rf /usr/local/apache*
     fi
   }

   rm_all(){
     if [[ /root/*.tar.gz ]]
     then
       rm -rf httpd* 
       rm -rf php* 
     fi
   }

   port_change_dic(){
     # Port change and directory index.php
     sed -i 's/Listen 80/Listen 81/g' /usr/local/apache/conf/httpd.conf
     sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/g' /usr/local/apache/conf/httpd.conf
     check 
   }
     

   rm_apache
   rm_all

#   echo "removing nginx"
#   apt-get -y purge nginx
#   /etc/init.d/nginx stop
   echo "removing apache2"
   apt-get -y purge apache2
   /etc/init.d/apache2 stop
   echo "Installing apr-dev and utils"
   apt-get install libapr1-dev libaprutil1-dev

   #echo "Downloading apache server"
   #wget http://10.0.0.1/httpd-2.2.29.tar.gz
   #check wget_httpd
   cd /tmp
   echo "Untaring httpd and install"
   tar xvzf apache.tar.gz
   cd httpd-2.2.29
   ./configure --prefix=/usr/local/apache --enable-so
   make
   make install
   port_change_dic
   EOH
end

service "apache2" do
  provider Chef::Provider::Service::Init::Debian
  subscribes :restart, resources(:bash => "apache2_debian_sc")
  supports :restart => true, :start => true, :stop => true 
end

template "apache.start.conf.erb" do
         path "/etc/init.d/apache2"
         source "apache.start.conf.erb"
         owner "root"
         group "root"
         mode "0755"
end


service "apache2" do
     provider Chef::Provider::Service::Init::Debian
     supports :restart => true, :start => true, :stop => true
     action [:enable, :start]
end
 
file "/tmp/apache.tar.gz" do
    action :delete
end

directory "/tmp/httpd-2.2.29" do
    recursive true
    action :delete
end
