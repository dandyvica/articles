# Automating Linux provisionning with Ansible

## Ansible installation
```console
$ sudo apt-get install ansible
```

## Inventory
The first step is to define an invetory file where all your hosts are defined.

Then check if your host is accessible using:
```console
$ ansible all --list-hosts --inventory=my_inventory
```

## Task automation
Create a playbook

Launch the playbook:

```console
$ ansible-playbook playbook.yml --inventory=my_inventory --user=root
```