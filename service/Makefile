up:
	$(MAKE) ssh-config
	docker-compose up

connect:
	block openvpn script/server default $(shell pwd)/docker-for-mac.ovpn

ssh_host := $(shell docker inspect service_latest_1 2>/dev/null | jq -r '.[0].NetworkSettings.Networks.service_default.IPAddress') $(opt)

ssh:
	$(MAKE) ssh-config
	ssh-keyscan $(ssh_host) > .ssh/known_hosts
	ssh -A -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(ssh_host) $(opt)

init:
	$(MAKE) ssh-config
	tx init $(ssh_host) -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(opt)

attach:
	tx $(ssh_host)

ssh-config:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/

