<# extra comment #>

<# Overview
this script will query the network for the name of the
primary domain controller emulater and the domain, search AD,
filter the output to display user accounts,
and clean-up the output so it's easier to read.
#>

<# Components
DirectorySearcher <--an object
ldap <--a protocol
#>

#ldap provider path
#LDAP://HostName[:PortNumber][/DistinguishedName]

$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

$PDC = ($domainObj.PdcRoleOwner).Name

$SearchString = "LDAP://"

$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$SearchString += $DistinguishedName

$SearchString

$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$Searcher.SearchRoot = $objDomain

<# FILTERS #>

$Searcher.filter = "samAccountType=805306368"

$Result = $Searcher.FindAll()

<# FANCY #>

Foreach($obj in $Result)
{
	Foreach($prop in $obj.Properties)
	{
		$prop
	}
	Write-Host "________________________"
}
