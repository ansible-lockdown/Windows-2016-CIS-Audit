# Example of a windows goss setup

## Requirements

- Goss to be on the host running the audit _ note its current alpha but works well
  - need to set environment

``` sh
$env:GOSS_USE_ALPHA=1
```

- Suggest reboot and gpupdate is run prior to audit - will potentially give differing results

- Permissions to run all the commands may need admin to run this
- top of vars file to state the type of server  Domain Controller, Domain Member or Standalone
  - also if iis or exchange is installed

## All server types

- gpresult /v /r > file_location.txt need to be created (variable gpresult_file  needs to be updated)
- auditpol.exe /get /category:* > file_location.txt ( the variable auditresults_file needs to be updated)

### If standalone server will require this

- secedit /export /cfg {{ file output location }} ( variable standalone_policies.txt )
- Due to the output we need to search for SID for std users using the MS doc below
  - https://docs.microsoft.com/en-us/troubleshoot/windows-server/identity/security-identifiers-in-windows
  - also added to vars for completeness

### Overview

This is the start of the layout for windows goss framework
Its has the following setup

- goss.yml - the main goss file to run (has to be used with a -g) - this loads all the sections as required
- vars.yml - These are the variable used as part of the goss file - this is split into sections to control the variables - will get BIG

- Try to reuse as much as possible
- use variables where you can to shorten and be more efficient in the code
- Build variables up
- Some control only work on DC or MS - settings in Vars to determine (will be populated by ansible when run from task)
- some controls written twice (due to different vars for a DC or MS)e.g. 2.2.7

### How it works

- GPO settings goss runs the powershell script ./scripts/gpo_regex.ps1 with arguments is run to search for the matching policy name
  - Will output the details if defined
  - if nothing is found will output "Not Defined"

- Where registry keys can be found and aligned this is run directly in goss to capture output

## To be done

- sign off on layout
- write it
- test it
- section_19 full test due to sid maybe required - may need to find from command and set as variable

```sh
  [Security.Principal.WindowsIdentity]::GetCurrent().user.value
```

## Example

### Manual powershell reg check command

```script
powershell -noprofile -noninteractive -command "(get-itemproperty -path 'HKLM:/SYSTEM/CurrentControlSet/Control/Lsa/').restrictanonymous"
```

### Broken into variables - make it easier to reuse and read

```script
ps_regcheck: powershell -noprofile -noninteractive -command

HKLM_CCS_LSA: (get-itemproperty -path 'HKLM:/SYSTEM/CurrentControlSet/Control/Lsa/')
```

### Command - note the quotes around the regpath

```script
{{ .Vars.ps_regcheck }} "{{ .Vars.HKLM_CCS_LSA }}.restrictanonymous"
```
