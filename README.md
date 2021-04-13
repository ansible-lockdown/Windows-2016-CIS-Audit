# Example of a windows goss setup

## Requirements

Goss to be on the host running the audit
Permissions to run all the commands may need admin to run this
top of vars file to state the type of server
if reboots are outstanding on the host this may change results

### Overview

This is the start of the layout for windows goss framework
Its has the following setup

- goss.yml - the main goss file to run (has to be used with a -g) - this loads all the sections as required
- vars.yml - These are the variable used as part of the goss file - this is split into sections to control the variables - will get BIG
- test-goss.txt - a text file to test the file commands and contains options
- testing.yml - a goss.yml file to test vars with

- Try to reuse as much as possible
- use variables where you can to shorten and be more efficient in the code
- Build variables up
- Some control only work on DC or MS - settings in Vars to determine (will be populated by ansible when run from task)
- some controls written twice (due to different vars for a DC or MS)e.g. 2.2.7

## To be done

- sign off on layout
- write it
- test it

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
