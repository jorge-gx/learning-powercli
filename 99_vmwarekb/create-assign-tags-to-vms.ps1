# Creating tags and assigning tags to the list of VMs using PowerCLI

# This script help you to create New Tags along with the new Tag Category if not existing.
# Script can assign the tags to the all the VMs present in vSphere Environment.

$FileContent = Get-Content c:\scripts\vmnames.txt

$uTagName = Read-Host "Enter VM Tag Name"

Try {
    #Assign Tag to VM
    $GetVMTag = Get-Tag -Name $uTagName -ErrorAction Stop
    Write-Host "TagName found"
    foreach ($VMinFile in $FileContent) {
        Get-VM $VMinFile | New-TagAssignment -Tag $GetVMTag
    }
    Write-Host "Tag Assignment completed"
}
Catch {
    Write-Host "Tag name you entered not found, let's create one"
    $YesOrNo = Read-Host "Please confirm, if you would like to proceed further (Y/N)"
    if (($YesOrNo -eq 'y') -or ($YesOrNo -eq 'Y')) {
        $uTagCatName = Read-Host "Enter Tag Categaory under which you would like to create new Tag"
        Try {
            $GetVMTagCat = Get-TagCategory -Name $uTagCatName -ErrorAction Stop
            Write-Host "TagCategory found"
            $uNewTagName = Read-Host "Enter New Tag name"
            $uNewTagDes = Read-Host "Enter Tag Description"
            New-Tag -Name $uNewTagName -Category $GetVMTagCat -Description $uNewTagDes
        }
        Catch {
            Write-Host "TagCategory you entered not found, let's create one"
            $uNewTagCatName = Read-Host "Enter New TagCategory name"
            $uNewTagCatDes = Read-Host "Enter TagCategory Description"
            New-TagCategory -Name $uNewTagCatName -Description $uNewTagCatDes
            Write-Host "Now, let's create a new Tag under TagCategory:" $uNewTagCatName
            $uNewTagName = Read-Host "Enter New Tag name"
            $uNewTagDes = Read-Host "Enter Tag Description"
            New-Tag -Name $uNewTagName -Category $uNewTagCatName -Description $uNewTagDes
        }
        #Assign Tag to VM
        $GetVMTag = Get-Tag -Name $uNewTagName -ErrorAction Stop
        foreach ($VMinFile in $FileContent) {
            Get-VM $VMinFile | New-TagAssignment -Tag $GetVMTag
        }
    }
    Write-Host "Tag Assignment completed"
}
