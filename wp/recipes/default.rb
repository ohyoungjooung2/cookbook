#
# Cookbook Name:: wp
# Recipe:: default
# Installing wordpress(mysql db, user addition and password)
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
template '/root/wordpress_config.sh' do
   source 'wordpress_config.sh.erb'
end
#
template '/root/mysql_add_db_user_for_wordpress.sh' do
   source 'mysql_add_db_user_for_wordpress.sh.erb'
end
bash "wp" do
     user "root"
     cwd "/root"
     code <<-EOH
     wget http://wordpress.org/latest.tar.gz
     mv latest.tar.gz /usr/local/apache/htdocs
     cd /usr/local/apache/htdocs
     tar xvzf latest.tar.gz
     cd /root
     bash mysql_add_db_user_for_wordpress.sh
     bash wordpress_config.sh
    EOH
end

