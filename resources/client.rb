#
# Author:: Corey Hemminger
# Cookbook:: windows_dns
# Resource:: client
#
# Copyright:: 2019, Netgain Technology, LLC.
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

description 'Configure DNS server settings for an interface'

property :interface_alias, String,
         required: true,
         default: lazy { node['network']['interfaces'][node['network']['default_interface']]['instance']['net_connection_id'] },
         description: 'Interface to configure DNS settings on'

property :domain_servers, Array,
         default: [],
         description: 'IP\'s of DNS servers'

property :search_domains, Array,
         default: [],
         description: 'Domain suffix to append short hostnames when searching DNS.'

action :configure do
  description 'Configure DNS settings for interface'

  powershell_script 'Set Interface DNS Search Servers' do
    code wmi_call("SetDNSServerSearchOrder(@(\"#{new_resource.domain_servers.join('","')}\"))")
    not_if { new_resource.domain_servers.empty? }
    not_if { new_resource.domain_servers.include?(powershell_out(wmi_call('DNSServerSearchOrder')).stdout.strip) }
  end

  powershell_script 'Set Interface DNS Search Suffixes' do
    code <<~EOS
      $wmi = [wmiclass] "win32_networkadapterconfiguration"
      $wmi.SetDNSSuffixSearchOrder(@("#{new_resource.search_domains.join('","')}"))
    EOS
    not_if { new_resource.search_domains.empty? }
    not_if { new_resource.search_domains.include?(powershell_out(wmi_call('DNSDomainSuffixSearchOrder')).stdout.strip) }
  end
end

action :unconfigure do
  description 'Remove DNS settings and use DHCP settings'

  powershell_script 'Set Interface DNS Search Servers' do
    code wmi_call('SetDNSServerSearchOrder()')
  end

  powershell_script 'Set Interface DNS Search Suffixes' do
    code <<~EOS
      $wmi = [wmiclass] "win32_networkadapterconfiguration"
      $wmi.SetDNSSuffixSearchOrder()
    EOS
  end
end

action_class do
  def wmi_call(method)
    <<~EOS
      $wmi = Get-WmiObject win32_NetworkAdapter -filter 'NetConnectionID = "#{new_resource.interface_alias}"'
      $wmi = Get-WmiObject win32_NetworkAdapterConfiguration -filter "Index=$($wmi.index)"
      $wmi.#{method}
    EOS
  end
end
