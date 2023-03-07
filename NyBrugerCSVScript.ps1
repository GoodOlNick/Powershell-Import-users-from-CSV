# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory

# Definer CSV-filens sti og parameter
$csvPath = "C:\Users.csv"
$delimiter = ","

# Importer users from the CSV file
$users = Import-Csv $csvPath -Delimiter $delimiter

# Loop through each user and create an AD account
foreach ($user in $users) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $streetaddress = $User.streetaddress
    $city = $User.city
    $email = $User.email
    $zipcode = $User.zipcode
    $country = $User.country
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department
    $OU = $User.ou

    #Check if user already exist
    $existingUser = Get-ADUser -Filter {SamAccountName -eq $user.Username} -ErrorAction SilentlyContinue

    if (!$existingUser){
        New-ADUser `
        -DisplayName "$lastname, $firstname" `
        -FirstName $firstname `
        -LastName $lastname `
        -SamAccountName $username `
        -Email $email `
        -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
        -Enabled $true `
        -OrganizationalUnit $OU `
        -Initials $initials `
        -Company $company `
        -Title $jobtitle ` 

        #If user was created
        Write-Host "Brugeren $username blev oprettet i Active Directory." -ForegroundColor Cyan
    }
    else {
    Write_Host "Bruger $user.Username eksistere allerede i Active Directory." -ForegroundColor Red
    }
}

Read-Host -Prompt "Tryk [Enter] for at lukke"
