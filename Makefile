SHELL := /bin/bash

new_key:
	ssh-keygen -t rsa -b 4096 -o -a 100 -f deploy/id_rsa

write_key:
	echo $$TDN_DEPLOY_PUB_KEY > ./deploy/id_rsa.pub
	echo "$$TDN_DEPLOY_PRIVATE_KEY" > ./deploy/id_rsa

remote_setup_user:
	ansible-playbook deploy/root.yml -i deploy/production.inventory --ask-pass

remote_secure_ssh:
	ansible-playbook deploy/secure.yml -i deploy/production.inventory --key-file deploy/id_rsa
