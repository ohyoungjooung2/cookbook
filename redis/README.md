redis Cookbook
==============
Redis for centos6.5,ubuntu14.04


This cookbook makes you install redis server and start file on centos65,ubuntu14.04 server. Other versions are not tested yet.

Requirements
------------
ubuntu14.04, centos65 are tested. So, these two distros are required.

e.g.
#### packages
Source stable version release

Attributes
----------

#### redis::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['redis']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### redis::default

Just include `redis` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[redis]"
  ]
}
```
Or, sudo chef-client -o redis from client etc.

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
I referred below site first and add sysv init script, instead of Upstart.
http://reiddraper.com/first-chef-recipe/

License: Aapche2.0
 Reid Draper@reiddraper 
 ohyoungjooung(wnapdlf05@gmail.com)

