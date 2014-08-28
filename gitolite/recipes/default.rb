

#
# Cookbook Name:: gitolite
# Recipe:: default
#
# CopyriGHt 2014, Your Company, Inc.
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
URL=node[:go][:url]
PK=node[:go][:pk]
GH=node[:go][:home]
USER=node[:go][:user]
GROUP=node[:go][:group]

case node["platform"]
when "debian","ubuntu"
 package "git" do
   action :install
 end
when "redhat","centos","fedora"
 package "git" do
     action :install
  end
 end

group "#{GROUP}" do
  action :create
  system false
end

user "#{USER}" do
  action :create
  #supports :manage_home => true
  home "#{GH}"
  system false
  group "#{GROUP}"
  shell "/bin/bash"
end

  
directory "#{GH}" do
     action :create
     user "#{USER}"
     group "#{GROUP}"
end


cookbook_file "#{GH}/#{PK}" do
  source "oyj.pub.erb"
  mode 0400
  owner "#{USER}"
end

directory "#{GH}/gitolite" do
     action :create
     user "#{USER}"
     group "#{GROUP}"
end


directory "#{GH}/bin" do
     action :create
     user "#{USER}"
     group "#{GROUP}"
end

git "/home/git/gitolite" do
  repository "#{URL}"
  reference "master"
  action :sync
end

bash "git_clone_gitolite" do
  #user "#{USER}"
  #group "#{GROUP}"
  cwd "/home/git"
  code <<-EOH
#   git clone #{URL}
    export HOME="#{GH}"
    export PATH="#{GH}/bin:$PATH"
    "#{GH}"/gitolite/install -ln
    "#{GH}"/bin/gitolite setup -pk "#{PK}"
    chown -R "#{USER}:#{GROUP}" "#{GH}"
  EOH
end

file "/#{GH}/#{PK}" do
     action :delete
     backup false
end
