describe powershell('if ((Get-DnsClientGlobalSetting | select -ExpandProperty suffixsearchlist) -eq "chef.local"){$true}else{$false}') do
  its('strip') { should eq 'True' }
end

describe powershell('if ((Get-DnsClientGlobalSetting | select -ExpandProperty serversearchorder) -eq "8.8.8.8"){$true}else{$false}') do
  its('strip') { should eq 'True' }
end
