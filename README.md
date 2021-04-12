# Example of a windows goss setup

## Requirements

Goss to be on the host running the audit
Permissions to run all the commands may need admin to run this

### Overview

This is the start of the layout for windows goss framework
Its has the following setup

- goss.yml - the main goss file to run (has to be used with a -g)
- vars.yml - These are the variable used as part of the goss file
- test-goss.txt - a text file to test the file commands and contains options

- Try to reuse as much as possible
- use variables where you can to shorten and be more effiecient in the code
- Build variables up

## To be done

- sections to be split into folders to minimise size of the files

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
