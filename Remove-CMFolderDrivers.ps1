<#
.Synopsis
   SCCM Shipped without a cmdlet to remove packages from a folder! This tool fixes that.
.DESCRIPTION
   Use this tool to delete Packages which are within a folder in SCCM.  Simply specify your folder name and site code, and the tool will enumerate the contents of a folder, find the right package ID, then provide that to the Remove-CMPackage cmdlet.
.EXAMPLE
   Remove-CMFolderPackages -Foldername DeleteMe

   >Remove
    Are you sure you wish to remove Package: Name="Deleteme"?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
.EXAMPLE
   Remove-CMFolderPackages -Foldername DeleteMe -WhatIf
   What if: Performing the operation "Removing Package" on target "HamIsGood".
#>
Function Remove-CMFolderPackages {
[CmdletBinding(SupportsShouldProcess=$true)]
param($foldername,$siteCode='F0X')

begin{
    try {$Folder = Get-CimInstance -Namespace root\sms\site_$siteCode -ClassName SMS_ObjectContainerNode -ea STOP| ? Name -like $foldername | ? ObjectTypeName -eq SMS_Package}
    catch {Write-Warning "Check the site code, Query error when looking at root\sms\site_$siteCode" }
    Write-Verbose "Found $($($Folder | measure).Count) items"
    
    try {$PackagesToDelete = Get-CimInstance -Namespace root\sms\site_$siteCode -ClassName SMS_ObjectContainerItem -EA STOP| ? ContainerNodeID -eq $folder.ContainerNodeID}
    catch {Write-Warning "Check the site code, Query error when looking at root\sms\site_$siteCode" }
    Write-Verbose "Found $($($PackagesToDelete | measure).Count) items to remove"
}
Process
    {
        
    #Remove the -whatif after confirming you're deleting the right packages
    ForEach ($package in $PackagesToDelete){
        $packageReference = Get-CMPackage -ID $package.InstanceKey 
        if ($pscmdlet.ShouldProcess("$($packageReference.Name)", "Removing Package"))
            {
            Remove-CMPackage -ID $packageReference.PackageID -errorAction STOP
            }
    }

}
}