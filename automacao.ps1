### INSTALAÇÃO ###

###PRIMEIRA INSTALAÇÃO###
$invitations = import-csv c:\file.csv -Header @("Name","InvitedUserEmailAddress","Date")

	$credential = Get-Credential
	$credential.Password | ConvertFrom-SecureString | Out-File C:\account.txt
##FIM PRIMEIRA INSTALAÇÃO###

$securestring = Get-Content C:\account.txt | ConvertTo-SecureString

$Username = "cayo@koniaaddemo.onmicrosoft.com"    
$Credential = New-Object System.Management.Automation.PSCredential($Username, $securestring)
Connect-AzureAD $Credential

### FIM INSTALAÇÃO ###



### SETAGEM DE VARIÁVEIS ###

$patch = c:\file_insercao.csv
$patchremove = c:\file_remocao.csv
 
### FIM SETAGEM DE VARIÁVEIS ###



### INSERÇÃO ###
$invitations = import-csv $patch -Header @("Name","InvitedUserEmailAddress","Date")


foreach ($values in $invitations)
{
	$userName = $values.Name
	$objectId = (Get-AzureADUser | where {$_.DisplayName -eq $userName}).ObjectID;
	if(!$objectId){
		$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
		$PasswordProfile.Password = "Teste@" + 
		(
			$values.InvitedUserEmailAddress[0] + 
			$values.InvitedUserEmailAddress[1] + 
			$values.InvitedUserEmailAddress[2]
		);
	New-AzureADUser -AccountEnabled $True -DisplayName $values.Name -PasswordProfile $PasswordProfile -MailNickName $values.Name -UserPrincipalName ($values.InvitedUserEmailAddress + "@koniaaddemo.onmicrosoft.com")
	}
}

### FIM INSERÇÃO ###

### REMOÇÃO ###
$invitations = import-csv $patchremove -Header @("Name","InvitedUserEmailAddress","Date")

foreach ($values in $invitations)
{
	$userName = $values.Name
	$objectId = (Get-AzureADUser | where {$_.DisplayName -eq $userName}).ObjectID;
	if($objectId){
		Remove-AzureADUser -ObjectID $objectId
	}
}

### FIM REMOÇÃO ###
