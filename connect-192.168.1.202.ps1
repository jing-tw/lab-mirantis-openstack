
$esxi_host_ip='192.168.1.202'
$user='root'
$passwd='1234567'
set-executionpolicy remotesigned
. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

Connect-VIServer -Server $esxi_host_ip -User $user -Password $passwd

