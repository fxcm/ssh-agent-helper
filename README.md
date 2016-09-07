# ssh-agent-helper
ssh-agent-helper

## Overview
Challenge:  You have a script/program that needs to scp/sftp/etc. files from one server to another, and since you're a responsible admin, you want to do it securely.

Problems:
  1. You do not want to have an ssh key around that doesn't have a password.
  2. You cannot type in a password each time the program runs.

Solution:  ssh-agent-helper.

## How it works
ssh-agent-helper consists of three components:
  1. the [ssh-agent-helper](ssh-agent-helper) script.
  2. a [wrapper](run-with-agent) for running your program with the agent that you started with ssh-agent-helper.
  3. a [nagios check](check_ssh_key) to ensure that the agent is running and has a key loaded.

### ssh-agent-helper
ssh-agent-helper takes two optional arguments:  a keyfile and a directory for the agent socket.  If the options are omitted, the script will use `ssh-add`'s defaults for keyfiles and will set `/var/run/<user>` as the socket directory.  When run, you will be asked for the key's password, and if entered successfully, the key will be loaded into the agent.
```
  myhost(~) % ssh-agent-helper -f /home/me/.ssh/id_rsa.git
  Enter passphrase for /home/me/.ssh/id_rsa.git:
  Identity added: /home/me/.ssh/id_rsa.git (/home/me/.ssh/id_rsa.git)
  myhost(~) %
```

### run-with-agent
Use this script to run a program using the agent that you started with ssh-agent-helper.  run-with-agent takes one optional argument and one required argument.  The optional argument, `-s`, is the full path to the ssh-agent socket.  This option is necessary if you set a custom socket directory in ssh-agent-helper.  If you used the default socket directory in ssh-agent-helper, this option can be omitted.  The required argument is the program you wish to run with the ssh-agent.
```
  myhost(~) % run-with-agent ssh git@github.com
  Hi me! You've successfully authenticated, but GitHub does not provide shell access.
  Connection to github.com closed.
```

### check_ssh_agent
Since your program is now relying on ssh-agent-helper's ssh-agent, you will need to know if there is no key in the agent -- or if the agent isn't running -- so that you can restart it.  Otherwise, your program will fail.  check_ssh_key takes one required argument:  the full path to the agent socket.
```
  myhost(~) % /usr/local/libexec/nagios/check_ssh_key /var/run/me/ssh-agent.sock
  OK: key is loaded
  myhost(~) %
```

## Packaging
A build script is included to build packages with these three utilites for FreeBSD and Linux.

## Things to remember
1. If the server where your program runs reboots, you will need to login to the server to start ssh-agent-help.
2. **YOUR SSH KEYS SHOULD ALWAYS HAVE PASSWORDS.**
3. Whenever possible, use purpose-built keys that use `commands=` in `authorized_keys`.

