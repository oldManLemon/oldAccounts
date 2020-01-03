Start-Sleep -s 5 
 
$File=import-csv .\MUC.csv
 
foreach ($entry in $File)
 
{ 
 
    Set-ADUser -Identity $($entry.DisplayName) -Enabled $false 
}