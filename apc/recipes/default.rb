#
# Cookbook Name:: apc
# Recipe:: default
# This cookbook is for configuring php option to apache httpd.conf file and restart apache server
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
template '/root/pata' do
   source 'php_add_to_apache.erb'
end

template '/root/index_php' do
   source 'index.php.erb'
end

bash "pac" do
     user "root"
     cwd "/root"
     code <<-EOH
         cat pata >> /usr/local/apache/conf/httpd.conf
         cp index_php /usr/local/apache/htdocs/index.php
         sleep 3
         /usr/local/apache/bin/apachectl restart
         EOH
end

