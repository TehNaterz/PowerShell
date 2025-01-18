function buildDates($year)
	{
	[datetime]$startingDate = "January 1 $year"

	#write-Host "starting date is $startingDate"

	$theYear = @()
	$ordinal = 1
	$workingDate = $startingDate
	#$theYear | FT

	while($workingDate.Year -eq $startingDate.Year){
		$lastDate = $theYear[-1]
		if($lastDate -eq $null){
			#begin
			$theYear += new-object -TypeName psobject -Property @{
				Month = $workingDate.Month
				Day = $workingDate.Day
				Year = $workingDate.Year
				Weekday = $workingDate.DayOfWeek
				Ordinal = $ordinal
			}
		}
		else{
			if($lastDate.Month -eq $workingDate.Month){
			
				if($ordinal -eq 1 -and ($workingDate).AddDays(-7).month -eq $lastDate.Month){
					$ordinal ++
				}
				elseif($ordinal -eq 2 -and ($workingDate).AddDays(-14).month -eq $lastDate.Month){
					$ordinal ++
				}
				elseif($ordinal -eq 3 -and ($workingDate).AddDays(-21).month -eq $lastDate.Month){
					$ordinal ++
				}
				elseif($ordinal -eq 4 -and ($workingDate).AddDays(-28).month -eq $lastDate.Month){
					$ordinal ++
				}
			}
			else{
				#start a new month
				$ordinal = 1
			}
			
			$theYear += new-object -TypeName psobject -Property @{
				Month = $workingDate.Month
				Day = $workingDate.Day
				Year = $workingDate.Year
				Weekday = $workingDate.DayOfWeek
				Ordinal = $ordinal
			}
		}
		#is it the same month?

		
		$workingDate =$workingDate.AddDays(1)
	}

	$theYear
}


function numbertoMonth($num){
	$nmTable = @(
		"Januaray",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	)
	$nmTable[$num -1]
}

function monthtonumber($mon){
	$mnTable = @(
		"Januaray",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	)
	([array]::IndexOf($mnTable, $mon))+1
}

function outputBuild($dateObj,$holObj){
	New-Object -TypeName psobject -Property @{
		Holiday = $holObj.Holiday
		Weekday = $dateObj.Weekday
		Month = (numbertoMonth $dateObj.Month)
		MonthIdx = $dateObj.Month
		Day = $dateObj.Day
		Year = $dateObj.Year
	}
}