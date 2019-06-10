# windows_dns Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/windows_dns.svg)](https://supermarket.chef.io/cookbooks/windows_dns)
[![Build status](https://ci.appveyor.com/api/projects/status/08ufviinkdtwi7vm/branch/master?svg=true)](https://ci.appveyor.com/project/ChefWindowsCookbooks/windows-dns/branch/master)

This cookbook provides a resource for managing DNS on Windows hosts.

## Requirements

### Platforms

- Windows Server 2008R2
- Windows Server 2012R2
- Windows Server 2016
- Windows Server 29019

### Chef

- Chef 14

## Resources

## windows_dns_record

Creates a DNS record for the given domain

#### Actions

- :create: creates/updates the DNS entry
- :delete: deletes the DNS entry

#### Properties

- `record_name` : The name of the record to create, eg: calaserver01
- `zone` : The zone to create the record in, eg: dst.calastone.com
- `target` : The target for the record
- `record_type` : The type of record to create, can be either ARecord, CNAME or PTR

#### Examples

```ruby
# Create CNAME record
windows_dns_record 'chefserver' do
  record_type 'cname'
  zone        'chef.local'
  target      'web01.chef.local'
end
```

## windows_dns_zone

Creates an Active Directory Integrated DNS Zone on the local server

#### Actions

- :create: creates/updates the DNS Zone
- :delete: deletes the DNS Zone

#### Properties

- `zone_name` : The name of the zone to create, eg: calastone.com
- `replication_scope` : The replication scope for the zone, defaults to Domain, required for server_type Domain
- `server_type` : The type of DNS server, Domain or Standalone

#### Examples

```ruby
# Create DNS Zone
windows_dns_zone 'chef.local' do
  server_type 'standalone'
end
```

## windows_dns_client

Configures interface DNS settings on the local server

#### Actions

- :configure: Sets static DNS search server IP's and DNS suffixes to search
- :unconfigure: Reverts settings back to DHCP

#### Properties

- `interface_alias` : String, Interface name to configure DNS settings on, defaults to `node['network']['interfaces'][node['network']['default_interface']]['instance']['net_connection_id']`
- `domain_servers` : Array, IP's of DNS servers
- `search_domains` : Array, Domain suffix to append to short hostnames when searching DNS, this property is global to all interfaces on a server

#### Examples

```ruby
# Set DNS servers IP and Search suffix for Ethernet 2

windows_dns_client 'default_interface' do
  interface_alias 'Ethernet 2'
  search_domains ['chef.local']
  domain_servers %w(192.168.1.1 192.168.1.2)
end

```

## License
```
Copyright 2018, Calastone Ltd.
Copyright 2018, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
