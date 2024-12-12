# Ensure PowerCLI is installed and connected to vCenter
# Connect to vCenter if not already connected
# Connect-VIServer -Server <Your vCenter Server> -User <Your Username> -Password <Your Password>

# Specify the VM name or get all VMs
$vmName = "Your_VM_Name"  # Replace with the desired VM name

# Get the VM object
$vm = Get-VM -Name $vmName

# Gather basic VM information
$vmInfo = @{
    Name             = $vm.Name
    CPU              = $vm.NumCpu
    Memory           = $vm.MemoryGB
    PowerState       = $vm.PowerState
    OS               = $vm.Guest.OSFullName
    IPAddress        = $vm.Guest.IPAddress
    Datastore        = $vm.Datastore.Name
    Host             = $vm.Host.Name
    VMToolsStatus    = $vm.ExtensionData.Guest.ToolsStatus
    CreatedDate      = $vm.ExtensionData.Config.CreateDate
    LastModified     = $vm.ExtensionData.Config.Modified
}

# Display basic information
$vmInfo

# Get all tags associated with the VM
$tags = Get-TagAssignment -Entity $vm

# Prepare a list to store tag categories and values
$tagDetails = @()

foreach ($tag in $tags) {
    # Get the tag information
    $tagCategory = $tag.Tag.Category.Name
    $tagValue = $tag.Tag.Name

    # Add to list of tag details
    $tagDetails += @{
        Category = $tagCategory
        Value    = $tagValue
    }
}

# Display the tag information
$tagDetails | Format-Table -Property Category, Value

# To get custom tags (tags not part of predefined categories), check if the category is not predefined
$customTags = $tagDetails | Where-Object { $_.Category -notin @('VMware', 'vSphere') }  # Modify predefined categories as needed

# Display custom tags
$customTags | Format-Table -Property Category, Value
