$vmhosts = Get-VMHost

ForEach($vmhost in $vmhosts)
    {
    Write-Host "VM Host Name: " $vmhost.Name
    }

# getting other info for a host by referencing other properties

$vmhost.ConnectionState
$vmhost.Build
$vmhost.NumCPU
