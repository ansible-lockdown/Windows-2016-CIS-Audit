# Approach for GPO output and goss parsing

## Option 1 
1. Capture current GPO settings output to file - If set via one GPO e.g. cis
2. Parse file for each section
3. Using goss to parse the data


e.g. ps script
i)create report - if name of GPO is CIS?
Get-GPOReport -Name "CIS" -ReportType xml -path "c:\goss\cis_gpo_report.xml"

ii) Work on section to pull data (PS script example)

```ps
[xml]$gpoattr = Get-Content -Path C:\goss\cis_gpo_report.xml

$gpoattr.DocumentElement.Computer.ExtensionData.Extension.Account | Select-Object -Property Name, SettingBoolean, SettingNumber
```

iii) produces output similar to

```shell
Name                  SettingBoolean SettingNumber
----                  -------------- -------------
ClearTextPassword     false                       
LockoutBadCount                      5            
LockoutDuration                      15           
MaximumPasswordAge                   30           
MinimumPasswordAge                   1            
MinimumPasswordLength                14           
PasswordComplexity    true                        
PasswordHistorySize                  24           
ResetLockoutCount                    15  
```

PROS:
Keeps inline with CIS rules - one policy for CIS?
one file
Ability to seperate by section - debugging easier

CONS:
Only one GPO searched
Doesnt mean policy setting are live on host?? (to confirm)
parsing xml which may change?

## Option 2

Do we use gpresult instead?
e.g.
gpresult /x {filename}.xml

PROS:
captures all GPOs
captures applied polcies

CONS:
This file could get very big on large enterprise setups with multiple GPOs 
if a big forest access is needed to query all
May get resource intensive if above and loops
xml get more complex to debug.
Need to distinguish applicable rules (also a pro)

## Option 3

```shell
gpresult /r /v > {filename.txt} - captures over three lines? - manipulate out and join lines? K:v pair
```

e.g.

```shell
Get-Content .\win2016.txt | Select-String GPO: -Context 0,2
(read file )   (filename)   (grep       string) (add context 0 + 2 lines after) 
```

or exact GPO policy name

```shell
Get-Content .\win2016.txt | Select-String MaxRenewAge -Context 1,1
(read file )   (filename)   (grep       string) (add context 1 line before & 1 line after) 
```

```shell
              GPO: Default Domain Policy
>                 Policy:            MaxRenewAge
                  Computer Setting:  7
```

PROS:
captures all GPOs
only shows valid active settings

CONS:
This file could get very big on large enterprise setups with multiple GPOs 
if a big forest access is needed to query all
May get resource intensive if above and loops
xml get more complex to debug.
