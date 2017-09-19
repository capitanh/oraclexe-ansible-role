Oracle Express Ansible Role
=========

This role downloads and install Oracle Express Edition 11g Release 2 (version 11.2.0-1.0.x86_64)

Requirements
------------

Centos 6-7 or RedHat 6-7

Role Variables
--------------
```yaml
- download_dir:           # Directory to host downloaded archive
- oracle_http_port:       # Oracle Web Interface http port
- oracle_listener_port:   # Oracle listener port
- oracle_password:        # Oracle SYSTEM and SYS users initial password

```

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - oraclexe

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
