## Powershell script must be called via powershell to capture stdout with goss.
# expects to have a gpresult /r/v (run by admin or able to query GPO) file so it can parse the faile for settings

[CmdletBinding()]
param (
      [string] $filename,
      [string] $policyname
)
#$file = "C:\goss\gpresult_r.txt"
#$policyname = "BackupPrivilege"

if ([string]::isNullorEmpty($filename) -Or [string]::isNullorEmpty($policyname) ) {
  "filename or policy name has not been set" 
  Exit 1
}

else
{
$pattern = 'Policy:(\s+)' +[regex]::escape($policyname) +'(.*?)GPO:'
$string = Get-Content $filename
$result = [regex]::match($string, $pattern).Value -replace ('\s+', ' ') -replace ('GPO:', ' ')
$result
}
## How to Use
##
## ./gpo_regex.ps1 -filename c:\goss\regex_testing\gpresult.txt -policyname SystemTimePrivilege