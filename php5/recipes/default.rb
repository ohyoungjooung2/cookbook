#
# Cookbook Name:: php5
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


bash 'php5_debian_from_sc' do
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

   p_inst(){
    sudo apt-get -y install libxml2-dev
   }
 
   p_inst

   echo "Downloading php source"
   wget http://10.0.0.1/php-5.5.15.tar.gz
   check wget_php

   echo "untar and install php"
   tar xvzf php-5.5.15.tar.gz
   cd php-5.5.15
   ./configure --with-apxs2=/usr/local/apache/bin/apxs --with-mysql
   make && make install 
   echo "restarting apache"
   sleep 3
   /usr/local/apache/bin/apachectl restart
   echo "/usr/local/apache/bin/apachectl start" >> /etc/rc.local
   EOH
end

   file "/root/php-5.5.15.tar.gz" do
    action :delete
   end

   directory "/root/php-5.5.15" do
    recursive true
    action :delete
   end
