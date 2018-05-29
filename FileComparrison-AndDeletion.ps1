### FileComparrison-AndDeltion V1.0 by Nathan Crist - https://natesitnet.wordpress.com/
### This script is used for comparing files in 2 directoriess.
### It generates an SHA1 hash of each file in both directories for comparrison
### It will Output to a CSV in the directory the script is executed from
### It then deletes the file in Dir1

#get Parameters
param([string]$dir1="",[string]$dir2="")

#Break out if the user doesn't acknowledge the pending deletions
Write-Host -ForegroundColor red "WARNING! This will Delete the duplicated items located in $dir1! Do you want to continue y - n (n)"

$answer = "n"
$answer = Read-Host 

IF ($answer -ne "y")
    {
    Write-Host "Aborting!"
    exit
    }

#region Break out if not defined
IF($dir1 -eq "")
    {
    Write-Output "You Must Provide a Directory for Dir1"
    exit
    }
IF($dir2 -eq "")
    {
    Write-Output "You Must Provide a Directory for Dir2"
    exit
    }
#endregion

#region GetThe Files 
$fileDir1 = Get-ChildItem -Recurse $dir1

$fileDir2 = Get-ChildItem -Recurse $dir2

#endregion

#region Compute Hashes of Dir2 And store
#Define the hashes variable
$hashesDir2 = @()
foreach ($file2 in $fileDir2)
    {
    $hashesDir2 += Get-FileHash -Algorithm sha1 $file2.pspath
    }
#endregion

#$output = @{}

#Build the CSV and delete
$Output = foreach ($file1 in $fileDir1)
    {
    $fileHash1 = Get-FileHash -Algorithm sha1 $file1.pspath
    #$filepath1 = $file1.FullName
    
        foreach ($hashitem2 in $hashesDir2)
        {        
        $hashitem2PATH = $hashitem2.Path
        $hashitem1PATH = $fileHash1.Path
        IF($hashitem2.Hash -eq $filehash1.hash)
            {
                New-Object -TypeName PSObject -Property @{
                Dir1 = $hashitem1PATH
                #Hash1 += $filehash1.hash
                Dir2 = $hashitem2PATH
                #$Hash2 += $hashitem2.Hash
                } | Select-Object Dir1,Dir2
            #Delete the file in Dir1
            Remove-Item $file1.pspath
            } 
        }

    }

#Write the CSV
$Output | Export-Csv -Path ".\DuplicateFiles.csv" -NoTypeInformation
