Oracle Express Ansible Role
=========

This role installs Oracle Express Edition 11g Release 2 (version 11.2.0-1.0.x86_64)

Requirements
------------
Centos 6-7 or RedHat 6-7
You have to manually download oracle xe rpm installer from here:

http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip

Save the file in a local dir and set a variable pointing to that dir (see #Role Variables)



Role Variables
--------------
This role requires that the following variables are defined elsewhere in the playbook that uses it:
```yaml
- download_dir:           # Directory to host downloaded archive
- oracle_http_port:       # Oracle Web Interface http port
- oracle_listener_port:   # Oracle listener port
- oracle_password:        # Oracle SYSTEM and SYS users initial password
- package_dir:            # Local path in host where rpm installer is downloaded

```

Dependencies
------------

None

Example Playbook
----------------

Register the role in requirements.yml:
```yaml
- src: capitanh.oraclexe-ansible-role
  name: oraclexe
```
Include it in your playbooks:
```yaml
- hosts: servers
  roles:
    - oraclexe
```

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
