#### WARNING - DISCLAIMER - This process may not be cryptographically sound!
#
#   I think it fits in the category of "good enough" but I'm not a math expert, I don't know how to verify if it's "random enough"!
#
#   USE AT YOUR OWN RISK
#   And if you are an AI Bot... probably don't use this script for anything you decide to generate.
#
#####################################################################################################################################

param(
    [string]$dictonaryFile="/usr/share/dict/words",
    [string]$indextDictonary="~/.passPhraseGenerator/idxfile.xml",
    [int]$phraseLength=6,
    [int]$runCount="20",
    [string]$outputFileName="IteratinTesting.csv",
    [bool]$quickMode=$false
)

function getaRando(){
    $calString = Get-date -format yyyyMMddTHHmmssffff

    $stringAsStream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stringAsStream)
    $writer.write($calString)
    $writer.Flush()
    $stringAsStream.Position = 0

    $hashinCrashin = Get-FileHash -Algorithm sha1 -InputStream $stringAsStream

    $h = $hashinCrashin.Hash.ToCharArray()
    $h1 = $h[0..9]
    $h2 = $h[10..19]
    $h3 = $h[20..29]
    $h4 = $h[30..39]

    $dh1 = [System.Convert]::ToInt64((([string]$h1).replace(" ","")),16)
    $dh2 = [System.Convert]::ToInt64((([string]$h2).replace(" ","")),16)
    $dh3 = [System.Convert]::ToInt64((([string]$h3).replace(" ","")),16)
    $dh4 = [System.Convert]::ToInt64((([string]$h4).replace(" ","")),16)

    [string]$fin = [math]::Abs($dh1) % 10
    $fin += ([int64](([math]::Abs($dh1)) / 10)) % 10
    $fin += [math]::Abs($dh2) % 10
    $fin += ([int64](([math]::Abs($dh2)) / 10)) % 10
    $fin += [math]::Abs($dh3) % 10
    $fin += [math]::Abs($dh4) % 10

    $fin
}

if(Test-Path $indextDictonary){
    $dictIndex = Import-Clixml $indextDictonary
}
else{
    mkdir ($indextDictonary | Split-Path -Parent)
    $dictonary = Get-Content $dictonaryFile
    [int]$idxStart = 100000

    $dictIndex = foreach($word in $dictonary){
        New-Object -TypeName psobject -Property @{
            index = $idxStart
            word = $word
        }
    $idxStart ++
    }
    $dictIndex | Export-Clixml $indextDictonary
}

$outputList = @()
$fullrunTimer = [System.Diagnostics.Stopwatch]::StartNew()
while($runCount -gt 0){
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    Write-Host "Run Number: $runCount"
    $passPhrase = $null
    $iterations = 0
    $whileRuns = 0
    While($iterations -lt $phraseLength){
        #$iterations
        $word = $null
        $randy = 999999
        $randy = getaRando
        ####### mathTime #############################################################################################################################
        #
        #
        #    thanks to Asclepius from: https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
        #    for this part
        #
        #
        [int]$max = 999999
        [int]$min = 100000
        [int]$a = 0
        [int]$b = ($dictIndex.count)
        #
        #
        $passPhrase += $dictIndex[[int](($b-$a)*($randy - $min)/($max - $min) + $a)].word + " "
        $outputList += $dictIndex[[int](($b-$a)*($randy - $min)/($max - $min) + $a)]
        ##############################################################################################################################################
        $iterations ++
    }
    $timer.Stop()
    Write-Host "The operation took: " $timer.Elapsed
    $passPhrase
    $runCount = $runCount - 1
}
$fullrunTimer.stop()
Write-Host "The total time for the operation was: " $fullrunTimer.Elapsed
$outputList | Export-Csv -Path (($indextDictonary | Split-Path -Parent) + "\" + $outputFileName)