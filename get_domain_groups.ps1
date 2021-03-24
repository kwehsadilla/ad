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

$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$Searcher.SearchRoot = $objDomain

$Searcher.filter="(objectClass=Group)"

$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
	$obj.Properties.name
}
