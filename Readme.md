[![CircleCI](https://circleci.com/gh/tomnewport/circleci/tree/master.svg?style=svg)](https://circleci.com/gh/tomnewport/circleci/tree/master)

### New deployment notes

You currently have:

- A remote host
- With docker installed
- With SSH access as root
- SSH key pair (can be re-created using `make new_key`):
  - `TDN_DEPLOY_PUBLIC_KEY` - public key used for deployments
  - `TDN_DEPLOY_PRIVATE_KEY` - private key used for deployments

First we need to give the `deploy` user access via ssh - being able to ssh in
as root is BAD.

    make remote_setup_user

If this succeeds, the deploy user is now set up and ready! Test it using:

    ➜ echo "$TDN_DEPLOY_PRIVATE_KEY" > deploy/id_rsa
    ➜ ssh -i deploy/id_rsa deploy@tnewp.org sudo whoami
    root

We can still log in as root. This is bad.

    make remote_secure_ssh

Nice. We now have a fairly securely set up remote host which we can access via
ssh.

### SSL certificate notes

The SSL certificate needs updating once every 90 days. It is originally created using this command as root:

    certbot certonly \
      --dns-digitalocean \
      --dns-digitalocean-credentials ~/.do-api.ini \
      -d "*.tnewp.org" \
      -d "*.tdn.sh" \
      -d "tnewp.org" \
      -d "tdn.sh"
