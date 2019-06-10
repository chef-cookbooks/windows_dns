describe powershell('if (($dnsCGSetting = Get-DnsClientGlobalSetting; $dnsCGSetting.SuffixSearchList) -eq chef.local){$true}else{$false}') do
  its('strip') { should eq 'True' }
end

# powershell_script 'Set DNS Servers' do
#   code "Set-DnsClientServerAddress -InterfaceAlias #{new_resource.interface_alias} -ServerAddresses (\"#{new_resource.domain_servers.join('","')}\")"
#   not_if { new_resource.domain_servers.empty? }
#   not_if { new_resource.domain_servers.include?(powershell_out("$dnsServers = Get-DnsClientServerAddress -InterfaceAlias #{new_resource.interface_alias}; $dnsServers.ServerAddresses").stdout.strip) }
# end
#
# powershell_script 'Set DNS search suffix' do
#   code "Set-DnsClientGlobalSetting -SuffixSearchList @(\"#{new_resource.search_domains.join('","')}\")"
#   not_if { new_resource.search_domains.empty? }
#   not_if { new_resource.search_domains.include?(powershell_out("$dnsCGSetting = Get-DnsClientGlobalSetting; $dnsCGSetting.SuffixSearchList").stdout.strip) }
# end
