
# VPS Instance from Hetzner:

	- https://console.hetzner.cloud/
	- Debaian 10
	- Standard mit lokal SSD
	- CX11 oder CX21
	- No Volume
	- No Netzwerk
	- No Firewall
	- User data (see hetzner_user_data)
	- SSH Key AKTIVIEREN (ggf. vorher hinzufügen)
	- Name ist egal

## user data

The `user-data` functionality of Cloud-Init works as a Kickstarter for the server. It prepares you to have a basically working server to which you can logon via ssh with your private key. This also pulls this repository and installs Ansible.

# Execute Ansible:
```
cd /opt/nerdadventure
ansible-playbook deployment.yml -e @vars.vault.yml --ask-vault-pass
```

If it fails with
```
	TASK [security : get packages facts] ****************************************************************
	fatal: [localhost]: FAILED! => {"msg": "fragment_class is None"}

	PLAY RECAP ******************************************************************************************
	localhost                  : ok=16   changed=5    unreachable=0    failed=1
```

Wait 5 min and try again (maybe ansible wasn't fully installed yet)

**Reboot is necessary**

### Setup DNS:
Now configure the following subdomains:
```
workadventure 600 IN A <ip>
api.workadventure 600 IN A <ip>
back.workadventure 600 IN A <ip>
maps.workadventure 600 IN A <ip>
play.workadventure 600 IN A <ip>
pusher.workadventure 600 IN A <ip>
uploader.workadventure 600 IN A <ip>
```

### Start Workadventure (on the server)
```
cd /opt/workadventure/contrib/docker
docker-compose up -d
```

access `https://play.workadventure.<domain>`
