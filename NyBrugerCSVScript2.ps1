Import-Module ActiveDirectory
  
# Hent data fra csv fil og gem i variable
$ADUsers = Import-Csv C:\brugerliste.csv -Delimiter ";"

# Define UPN
$UPN = "nickogCarl.dk"

# Loop igennem felterne i csv filen
foreach ($User in $ADUsers) {

    #tilknyt variable til felt 
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou
    $email = $User.email
    $streetaddress = $User.streetaddress
    $city = $User.city
    $zipcode = $User.zipcode
    $state = $User.state
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Tjek om bruger er oprettet
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # Hvis oprettet skriv en warning til sk�rm
        Write-Warning "En bruger med brugernavn $username er allerede oprettet i Active Directory."
    }
    else {

        # Opret bruger
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # Hvis bruger er oprettet skriv
        Write-Host "Brugeren $username er oprettet." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Tryk p� en tast for at afslutte"