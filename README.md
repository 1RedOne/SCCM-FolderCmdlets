# SCCM-FolderCmdlets
SCCM shipped without good visibility of which items in the console are stored within folders.  None of the built-in Cmdlets even give you a way of sorting through these items, to see which are stored where.  

Enter these tools!

#What Works
Remove-CMFolderPackages works, with fully fledged -WhatIf support, and it will even autodiscover your site code, if you've got the SCCM Module imported!

#What Doesn't
The *-Application and *-Drivers cmlets don't do anything at this point, they're just copied and pasted.