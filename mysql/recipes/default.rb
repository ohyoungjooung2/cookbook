#
# Cookbook Name:: mysql
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

bash 'mysql_debian' do
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

   install_mysql(){
   service mysql stop;
   apt-get -y purge mysql-server-core-5.5 mysql-server
   echo "Installing mysql-server"
   sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password rootpass'
   sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password rootpass'
   sudo apt-get update
   sudo apt-get -y install mysql-server-5.5 
   echo $?
   }
   
   install_mysql
   EOH
end
