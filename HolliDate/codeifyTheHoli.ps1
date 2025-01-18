param(
    [string]$year="",
    [string]$holidayFile=""
)
. .\holiFunctions.ps1

if($holidayFile -eq ""){
    throw "You must specify a csv file with Holidays in it."
    exit 1
}


$dateData = buildDates $year
$holidays = Import-Csv $holidayFile

$finalOutput = @()

Foreach($holiday in $holidays){
    $final = $null
    if($holiday.Type -eq "Variable"){
        if($holiday.Ordinal -eq "Last"){
            $Selection=Foreach($date in $dateData | where {$_.Month -eq $holiday.Month} | where {$_.Weekday -eq $holiday.Weekday}){
                $date
            }
            $final = ($Selection | Sort-Object -Property Ordinal)[-1]
            $finalOutput += outputBuild $final $holiday
        }
        else{
            $final = $dateData | where {$_.Month -eq $holiday.Month} | where {$_.Weekday -eq $holiday.Weekday} | where {$_.Ordinal -eq $holiday.Ordinal}
            $finalOutput += outputBuild $final $holiday
        }    
    }
    elseif($holiday.Type -eq "Fixed"){
        $final = $dateData | where {$_.Month -eq $holiday.Month} | where {$_.Day -eq $holiday.Day}
        $finalOutput += outputBuild $final $holiday
    }
}

$finalOutput | Sort-Object -Property MonthIdx,Day