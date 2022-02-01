# Example of a windows goss setup

Detailed:

[How To Guide](Docs/how_to.MD)

## Requirements

- download goss (current version 0.3.6 - Alpha for windows)
  - [x86_64-goss](https://github.com/aelsabbahy/goss/releases/download/v0.3.goss-alpha-windows-amd64.exe)
  - validate SHA
- Goss to be on the host running the audit _ note its current alpha but works well
  - need to set environment

```txt
$env:GOSS_USE_ALPHA=1
```

- Suggest reboot and gpupdate is run prior to audit - will potentially give differing results

- Permissions to run all the commands may need admin to run this
- top of vars file to state the type of server  Domain Controller, Domain Member or Standalone
  - also if iis or exchange is installed

## Domain members and domain controllers

- gpresult /v /r > file_location.txt need to be created (variable gpresult_file  needs to be updated)
- auditpol.exe /get /category:* > file_location.txt ( the variable auditresults_file needs to be updated)

### If standalone server will require the following commands

- secedit /export /cfg {{ file output location }} ( variable standalone_policies.txt )
- auditpol.exe /get /category:* > file_location.txt
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

#### NOTE: Its expected to run from audit dir or to amend the script paths in vars accordingly

- GPO settings goss runs the powershell script ./scripts/gpo_regex.ps1 with arguments is run to search for the matching policy name
  - Will output the details if defined
  - if nothing is found will output "Not Defined"

- Where registry keys can be found and aligned this is run directly in goss to capture output

```txt
  [Security.Principal.WindowsIdentity]::GetCurrent().user.value
```

## Example

### Manual powershell reg check command

```txt
powershell -noprofile -noninteractive -command "(get-itemproperty -path 'HKLM:/SYSTEM/CurrentControlSet/Control/Lsa/').restrictanonymous"
```

### Broken into variables - make it easier to reuse and read

```txt
ps_regcheck: powershell -noprofile -noninteractive -command

HKLM_CCS_LSA: (get-itemproperty -path 'HKLM:/SYSTEM/CurrentControlSet/Control/Lsa/')
```

### Command - note the quotes around the regpath

```txt
{{ .Vars.ps_regcheck }} "{{ .Vars.HKLM_CCS_LSA }}.restrictanonymous"
```

## Example of manually running the audit

e.g. standalone server test

- Ensure the var.yml file is set for server type and relative paths to files are updated

e.g. file structure
```txt
- c:
  |- audit
   +-- goss.exe # assuming you have downloaded goss already
   +-- secedit_conf.txt
   +-- audit_pol.txt
   \--- Windows-2016-Audit
       +- goss.yml
       +- vars.yml
       +- <... other audit config ...>
```

Using powershell prompt on the host - will need to run as admin
```txt
PS > cd C:\audit\
PS C:\audit> secedit /export /cfg secedit_conf.txt
PS C:\audit> auditpol.exe /get /category:* > audit_pol.txt
PS C:\audit> cd .\Win2016-CIS-Audit\
PS C:\audit\Win2016-CIS-Audit> .\goss.exe -g .\Win2016-CIS-Audit\goss.yml --vars .\Win2016-CIS-Audit\vars.yml v
```
