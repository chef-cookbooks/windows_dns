describe powershell('if ((Get-DnsClientGlobalSetting | select -ExpandProperty suffixsearchlist) -eq "chef.local"){$true}else{$false}') do
  its('strip') { should eq 'True' }
end
