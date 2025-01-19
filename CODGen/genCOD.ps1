param(
    [string]$seedFile=""
)

if($seedFile -eq ""){
    throw "You must specify a seedFile"
    exit 1
}

$seed = Get-Content $seedFile

$calString = $seed + (Get-date -UFormat %s)

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