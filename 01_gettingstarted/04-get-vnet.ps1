# gets the list of networks, then pipe each one into where clause
# note the use of wildcards

Get-VirtualNetwork | Where {$_.Name -like "*vlan*"}
