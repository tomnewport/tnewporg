SHELL := /bin/bash

new_key:
	@ssh-keygen -t rsa -b 4096 -o -a 100 -f deploy/id_rsa

write_key:
	@echo "$$TDN_DEPLOY_PUBLIC_KEY" > ./deploy/id_rsa.pub
	@echo "$$TDN_DEPLOY_PRIVATE_KEY_B64" | base64 --decode > ./deploy/id_rsa
	@chmod 700 ./deploy/id_rsa

write_fingerprint:
	@mkdir -p ~/.ssh/
	@touch ~/.ssh/known_hosts
	@grep -Ev "104.248.168.106|tnewp.org" ~/.ssh/known_hosts > ~/.ssh/known_hosts.tmp  || true
	@echo "$$TDN_DEPLOY_SERVER_FINGERPRINT_B64" | base64 --decode >> ~/.ssh/known_hosts.tmp
	@mv ~/.ssh/known_hosts.tmp ~/.ssh/known_hosts

remote_setup_user:
	@ansible-playbook deploy/root.yml -i deploy/production.inventory --ask-pass

remote_secure_ssh:
	@ansible-playbook deploy/secure.yml -i deploy/production.inventory --key-file deploy/id_rsa

local_ssh_keys:
	mkdir -p ./keys
	openssl req -x509 -out localhost.crt -keyout localhost.key \
	  -newkey rsa:2048 -nodes -sha256 \
	  -subj '/CN=localhost' -extensions EXT -config <( \
	  printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
	mv localhost.crt tdn.crt
	mv localhost.key tdn.key
	mv tdn.crt keys/
	mv tdn.key keys/
