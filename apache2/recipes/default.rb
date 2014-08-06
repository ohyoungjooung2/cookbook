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

   rm_apache
   rm_all

   echo "removing nginx"
   apt-get -y purge nginx
   /etc/init.d/nginx stop
   echo "removing apache2"
   apt-get -y purge apache2
   /etc/init.d/apache2 stop
   echo "Installing apr-dev and utils"
   apt-get install libapr1-dev libaprutil1-dev

   echo "Downloading apache server"
   wget http://10.0.0.1/httpd-2.2.27.tar.gz
   check wget_httpd

   echo "Untaring httpd and install"
   tar xvzf httpd-2.2.27.tar.gz
   cd httpd-2.2.27
   ./configure --prefix=/usr/local/apache  --enable-so
   make
   make install
   echo "trying to start apache server"
   /usr/local/apache/bin/apachectl start

   EOH
end
   file "/root/httpd-2.2.27.tar.gz" do
    action :delete
   end

   directory "/root/httpd-2.2.27" do
    recursive true
    action :delete
   end
