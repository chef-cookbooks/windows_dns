# configure dns
dns_ip = []
search('node', 'run_list:*test??dns*').each do |dns_server|
  dns_ip << dns_server['ipaddress']
end

windows_dns_client 'default_interface' do
  search_domains ['chef.local']
  domain_servers dns_ip
end
