
# Creating tags and assigning tags to the list of VMs using PowerCLI

# This script help you to create New Tags along with the new Tag Category if not existing.
# Script can assign the tags to the all the VMs present in vSphere Environment.

# this uses a CSV file as input, creates multiple tag categories & tags
# This cmdlet reads the contents of a CSV (Comma-Separated Values) file and converts it into an array of PowerShell objects. 
# Each row in the CSV becomes an object, and each column in that row becomes a property of the object.

$FileContent = Import-CSV c:\data\cmdbinfo.csv

# Get the header names to use as Tag Category names

# The -Expand flag extracts the values of the Name property directly, 
# so the result is just a simple list of the property names (CSV column headers).

$TagCatNames = $FileContent | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" } | Select-Object -Expand Name

# Create the Tag Category if it doesn't exist

Foreach ($Name in ($TagCatNames | Where-Object { $_ -ne "Name" })) {

    if (-Not (Get-TagCategory $Name -ea SilentlyContinue)) {
        Write-Host "Creating new Tag Category $Name"
        New-TagCategory -Name $Name -Description "$Name from CMDB" | Out-Null

        # Now creete the tag under the Tag Category

        $UniqueTags = $FileContent | Select-Object -expand $name | Get-Unique

        Foreach ($Tag in $UniqueTags) {
            if (-not (Get-Tag $Tag -ea SilentlyContinue)) {
                write-host "Now creating Tag under $Name of $Tag"
                New-Tag -Name $Tag -Category $name -Description "$Tag from CMDB" | Out-Null
            }

            # Assign the Tags to the VMs
            $FileContent | Where-Object { $_.($Name) -eq $Tag } | ForEach-Object {
                write-host "Now Assigning $Tag in Category of $Name to $($_.Name)"
                $Tagassignment = Get-tag -Category $Name -name $Tag
                New-TagAssignment -entity $($_.Name) -Tag $Tagassignment | Out-null
            }
        
        }
    }
}
