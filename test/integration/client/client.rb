def wmi_call(nic_alias, method)
  <<~EOS
      $wmi = Get-WmiObject win32_NetworkAdapter -filter 'NetConnectionID = "#{nic_alias}"'
      $wmi = Get-WmiObject win32_NetworkAdapterConfiguration -filter "Index=$($wmi.index)"
      $wmi.#{method}
  EOS
end

describe powershell(wmi_call('Ethernet', 'DNSDomainSuffixSearchOrder')) do
  its('strip') { should eq 'chef.local' }
end

describe powershell(wmi_call('Ethernet', 'DNSServerSearchOrder'))  do
  its('strip') { should eq '8.8.8.8' }
end
