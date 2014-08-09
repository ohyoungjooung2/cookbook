#
# Cookbook Name:: oracle_java7
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
when "ubuntu"
 bash 'oracle_java_7_ubuntu' do
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

      get_java(){
        #http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux?rq=1
        wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.tar.gz -O jdk7.tar.gz
      }

     get_java
     check getting_java


     tar xvzf jdk7.tar.gz

     if [[ -d /usr/local/java ]] 
     then
        rm -rf /usr/local/java
     fi
     check remove_java
     
     mv jdk1.7.0_60 /usr/local/java
     for i in $(awk -F: '{if ($3 >= 1000 && $3 < 10000) print $1}' /etc/passwd)
     do
       echo "PATH=/usr/local/java/bin:$PATH" >> /home/$i/.bashrc
     done

    EOH
 
 end

 when "centos"
 bash 'oracle_java_7_centos' do
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

      get_java(){
        #http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux?rq=1
        wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.tar.gz -O jdk7.tar.gz
      }

     get_java
     check getting_java


     tar xvzf jdk7.tar.gz

     if [[ -d /usr/local/java ]] 
     then
        rm -rf /usr/local/java
     fi
     check remove_java
     
     mv jdk1.7.0_60 /usr/local/java
     for i in $(awk -F: '{if ($3 >= 500 && $3 < 10000) print $1}' /etc/passwd)
     do
       echo "PATH=/usr/local/java/bin:$PATH" >> /home/$i/.bashrc
     done

    EOH
 
 end
  
end

file "/root/jdk-7u60-linux-x64.tar.gz" do
     action :delete
     backup false
end
