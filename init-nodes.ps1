

$esxi_host_ip='172.16.219.130'
$user='root'
$passwd='1234567'
set-executionpolicy remotesigned
. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

Connect-VIServer -Server $esxi_host_ip -User $user -Password $passwd



#Step 1: Create port-group

$vswitch='vswitch0'

$port_group_array=@('Admin-PXE', 'Management', 'Storage', 'Public', 'Private')
$port_group_vlanid_array=@(0, 101, 102, 0, 1000)
for($i=0;$i -lt 5;$i++){
     $vportgroup=New-VirtualPortGroup -name $port_group_array[$i] -virtualswitch $vswitch -vlanid $port_group_vlanid_array[$i]
     Get-VirtualPortgroup -Name $port_group_array[$i] | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $true -MacChanges $true -ForgedTransmits $true
}

get-virtualportgroup


#Step 2: Create Fuel Master VM with hardware configuration
$host_name='fuel-master'
$hddGB_capacity=5
$memoryGB_capacity=2
$network_name='Admin-PXE'
new-vm -vmhost $esxi_host_ip -name $host_name -diskGB $hddGB_capacity -memoryGB $memoryGB_capacity -networkname $network_name -DiskStorageFormat thin 


#Step 3: Create 3 Slaves for controller, cinder, compute nodes with hardware configuration
$hddGB_capacity=5
$memoryGB_capacity=4

$node_array=@('slave-3nics-controller', 'slave-3nics-cinder', 'slave-3nics-compute')
foreach ($node_name in $node_array) {
	$objVM=new-vm -vmhost $esxi_host_ip -name $node_name -diskGB $hddGB_capacity -memoryGB $memoryGB_capacity -networkname 'Admin-PXE' -DiskStorageFormat thin 
	new-networkadapter -vm $objVM -networkname "VM Network" -wakeonlan -startconnected
	new-networkadapter -vm $objVM -networkname "VM Network" -wakeonlan -startconnected	
}