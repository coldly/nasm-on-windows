Install-Module -Name VcRedist -Force
Import-Module -Name VcRedist

$VcList = Get-VcList
New-Item -ItemType directory -Path C:\Temp\VcRedist
$VcList | Get-VcRedist -Path C:\Temp\VcRedist
Install-VcRedist -Path C:\Temp\VcRedist -VcList $VcList -Silent
