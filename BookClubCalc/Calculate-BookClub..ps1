param(
    [datetime]$ClubDate,
    [int]$bookLength
)

Write-Host "########################`r`n#`r`n#`r`n#    Nate's BookClub Calculator `r`n#`r`n#`r`n#########################`r`n"

iF($ClubDate -eq $null){
    $ClubDate = Read-Host "What is the date of club meeing?"
}
if($bookLength -eq 0){
    $bookLength = Read-Host "How many pages do you have left in the book?"
}

$today=Get-Date

$DaysRemaining = (New-TimeSpan -Start $today -End $ClubDate).Days

$dividend = $bookLength / $DaysRemaining

Write-Host "The number of pages you need to read per day is: $dividend"