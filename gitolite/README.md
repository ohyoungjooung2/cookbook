gitolite Cookbook
=================
git central server.

e.g.
This cookbook installs gitolite .
Gitolite Hosts Git Repositories


Requirements
------------
Ubuntu14.04,centos6.5 are tested.


#### packages
git package

Attributes
----------
default[:go][:user] = "git"
default[:go][:group] = "git"
default[:go][:url] = "git://github.com/sitaramc/gitolite"
default[:go][:pk] = "oyj.pub"
default[:go][:home] = "/home/git"

e.g.
#### gitolite::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['gitolite']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### gitolite::default
Pre: knife cookbook upload gitolite
1. From node "sudo chef-client -o gitolite"
2. Just include `gitolite` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[gitolite]"
  ]
}
```

Contributing

License and Authors
-------------------
Authors: ohyoungjooung@gmail.com, wnapdlf05@gmail.com 
