Oracle Express Ansible Role
=========

This role installs Oracle Express Edition 11g Release 2 (version 11.2.0-1.0.x86_64)

{:toc}

Requirements
------------
Centos 8 or RedHat 8 - Only python3 supported. You have to manually download oracle xe rpm installer from here:

http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip

Save the file in a local dir and set a variable pointing to that dir (see #Role Variables)



Role Variables
--------------
This role defines the following default variables
```yaml
- download_dir:           /tmp       # Directory to host downloaded archive
- oracle_http_port:       8080       # Oracle Web Interface http port
- oracle_listener_port:   1521       # Oracle listener port
- oraclexe_service_name:  oracle-xe  # OS service name
```

And the following ones need to be defined elsewhere in the playbook that uses the role:
```yaml
- oracle_env:                        # Environemts vbles needed to perform sqlplus operations
    ORACLE_HOME:            /u01/app/oracle/product/11.2.0/xe
    LD_LIBRARY_PATH:        /u01/app/oracle/product/11.2.0/xe/lib
    LC_ALL:                 en_US.UTF-8
- oracle_admin_user:      system     # Admin user name
- oracle_password:        ******     # Admin, sys and system users passwords (maybe encripted inside a vault)
```

Usage
--------------
To create and modify database objects, define them in variable files as this:
```yaml
oracle_tablespaces:
  - name: TABLESPACENAME                 # Table space logical name
    datafile: tablespace-filename.dbf    # Table space physical file name
    size: xM                             # (M for Mb, G for Gb and so on)

oracle_profiles:
  - name: PROFLENAME                     # Profile name
    attribute_name:                      # List of attributes to be different from the defaults
      - password_life_time
      - password_reuse_time
      - password_reuse_max
    attribute_value:                     # Values of attributes in the same order
      - unlimited
      - unlimited
      - unlimited
oracle_roles:
  - name: ROLENAME                       # Role name
    grants:                              # List of grants for the role
      - create table
      - create materialized view
      - create view
      - create synonym
      - create session
      - create public synonym
      - create trigger
      - drop public synonym
      - create sequence
      - create procedure
oracle_users:
  - name: USERNAME                        # User account name
    password: ***********                 # Account password (maybe encripted inside a vault)
    profile: PROFILENAME                  # One of existing profiles (can be one of the previously defined above)
    default_tablespace: TABLESPACENAME    # One of existing tablespace (can be one of the previously defined above) or don't specify this variable to use default one
    roles:                                # List of existing roles to be applied to user (can be one of the previously defined above).
      - role1
      - role2
oracle_privs:
  - role: ROLENAME                        # List of existing roles to be granted privileges (can be one of the previously defined above). Can also be an username
    privs:                                # System privs list to be granted to this role
      - select
      - insert
      - update
      - delete
    objs:                                 # Object privileges to be granted to this role (can be one of the previously defined above). Can also be an username.
      - USER1.%
      - TABLE1
      - TABLE2
```

Dependencies
------------
Requires cxOracle python module in target hosts. It should be possible to have it installed in control machine, but it has not been tested. To install cxOracle just run:
```bash
pip install cx_Oracle
```

Example Playbook
----------------
Register the role in requirements.yml:
```yaml
- src: capitanh.oraclexe-ansible-role
  name: oraclexe
```

Install the role in control machine:
```bash
ansible-galaxy install -r requirements.yml

```

Include it in your playbooks:
```yaml
---
- hosts: all
  roles:
    - capitanh.oraclexe-ansible-role
  environment: "{{oracle_env}}"
  tasks:
  - name: Create oracle tablespaces
    oracle_tablespace:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      tablespace: "{{item.name}}"
      datafile: "{{item.datafile}}"
      size: "{{item.size}}"
      state: present
    with_items: "{{oracle_tablespaces}}"

  - name: Create oracle profiles
    oracle_profile:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      state: present
      name: "{{item.name}}"
      attribute_name: "{{item.attribute_name}}"
      attribute_value: "{{item.attribute_value}}"
    with_items: "{{oracle_profiles}}"

  - name: Create oracle roles
    oracle_role:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      state: present
      role: "{{item.name}}"
    with_items: "{{oracle_roles}}"

  - name: Assign grants to oracle roles
    oracle_grants:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      state: present
      role: "{{item.name}}"
      grants: "{{item.grants}}"
    with_items: "{{oracle_roles}}"

  - name: Create oracle users
    oracle_user:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      schema: "{{item.name}}"
      schema_password: "{{item.password}}"
      default_tablespace: "{{item.default_tablespace}}"
      profile: "{{item.profile}}"
      grants: "{{item.roles}}"
      state: present
    with_items: "{{oracle_users}}"

  - name: Asign privs to roles
    oracle_privs:
      service_name: "{{oracle_service_name}}"
      user: "{{oracle_admin_user}}"
      password: "{{oracle_password}}"
      state: present
      roles: "{{item.role}}"
      privs: "{{item.privs}}"
      objs: "{{item.objs}}"
    with_items: "{{oracle_privs}}"

```

Credits
-------
This role makes intensive use of oravirt's excellent set of ansible modules for oracle:
https://github.com/oravirt/ansible-oracle-modules

