$vmhosts = Get-VMHost

ForEach($vmhost in $vmhosts)
    {
    Write-Host "VM Host Name: " $vmhost.Name
    }
