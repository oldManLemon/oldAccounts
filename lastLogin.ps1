#Search accounts in a certain base
#Search base
$FileList = "mucList.txt"
$ContenOfLists = Get-Content $FileList
$Station = "MUC"
#Avoid errors by forcing correct OU searches
switch ($Station) {
    "AIC" { $search = "OU=AIC," }
    "BER" { $search = "OU=BER," }
    "BER (TXL)" { $search = "OU=BER (TXL)," }
    "BRE" { $search = "OU=BRE," }
    "CGN" { $search = "OU=CGN," }
    "DUS" { $search = "OU=DUS," }
    "FRA" { $search = "OU=FRA," }
    "HAJ" { $search = "OU=HAJ," }
    "HAM" { $search = "OU=HAM," }
    "HQ" { $search = "OU=HQ," }
    "MUC" { $search = "OU=MUC," }
    "STR" { Return Write-Host "Funktioniert Nicht! Bitte Andrew Fragen" -ForegroundColor Red }
    Default { Return Write-Host "Station nicht wird nicht gefunden. Bitte checken!" -ForegroundColor Red }
}
# * Search base built here
$base = "OU=Stations,OU=x,DC=intern,DC=ahs-de,DC=com"
$searchbase = $search + $base
$searchbase
#* Search-ADAccount will not work unless you include -AccountDisabled or -LockedOut
$Results = Get-Aduser -SearchBase $searchbase -Filter * -Properties "LastLogonDate", "DisplayName"
# $ContenOfLists.GetType()


$Results | foreach {
    if ($_.LastLogonDate -lt (get-date 2019-11-01)) {
        if($ContenOfLists.Contains($_.DisplayName)) {
                new-object psobject -Property @{
                    DisplayName   = $_.DisplayName
                    LastLogonDate = $_.LastLogonDate
                } 
            }
       

        }
    

    } | Select DisplayName, LastLogonDate | Export-Csv $Station".csv" -Encoding Unicode