get-virtualportgroup
get-vm

# remove all port group
$port_group_array=@('Admin-PXE', 'Management', 'Storage', 'Public', 'Private')
foreach ($port_group_name in $port_group_array) {
	$obj=get-virtualportgroup -name $port_group_name
	remove-virtualportgroup -virtualportgroup $obj -confirm:$false
}

# remove all vm
$node_array=@('fuel-master', 'slave-3nics-controller', 'slave-3nics-cinder', 'slave-3nics-compute')
foreach ($node_name in $node_array) {
       Remove-VM -vm $node_name -DeletePermanently:$true -confirm:$false
}

get-virtualportgroup
get-vm

