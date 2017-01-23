chef_backend node['fqdn'] do
  bootstrap_node node['fqdn'] # TODO: make dynamic
  accept_license true
end
