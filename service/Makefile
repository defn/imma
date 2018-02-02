SHELL := bash

all:
	screen -X -S imma quit || true
	if [[ -f .pgroup ]]; then if sudo pkill -g "$(shell cat .pgroup)"; then sleep 5; if pgrep -g "$(shell cat .pgroup)"; then sudo pkill -9 -g "$(shell cat .pgroup)" || true; fi; fi; fi
	rm -f .pgroup
	screen -S imma -m $(MAKE) screen

screen:
	echo $$PPID > .pgroup
	$(MAKE) up
	$(MAKE) connect

up:
	$(MAKE) ssh-config
	#rm -f docker-for-mac.ovpn
	#sudo rm -rf config
	#git checkout config
	docker-compose build
	docker-compose up -d --force-recreate
	while [[ ! -e docker-for-mac.ovpn ]]; do sleep 1; done

connect:
	rm -f .connected
	while [[ ! -e docker-for-mac.ovpn ]]; do sleep 1; done && make init &
	block openvpn script/server default --script-security 2 --up "$(shell pwd)/script/up" --config "$(shell pwd)/docker-for-mac.ovpn"

ssh_host := $(shell docker inspect service_latest_1 2>/dev/null | jq -r '.[0].NetworkSettings.Networks.service_default.IPAddress')

ssh:
	$(MAKE) ssh-config
	ssh-keyscan $(ssh_host) > .ssh/known_hosts
	ssh -A -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(ssh_host) $(opt)

init:
	while ! $(MAKE) ssh opt="-o ConnectTimeout=1 true"; do sleep 1; done
	tx init $(ssh_host) -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(opt)

attach:
	$(MAKE) ssh opt=true
	tx $(ssh_host) -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(opt)

ssh-config:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/

