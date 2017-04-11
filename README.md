# installs

Installs all the necessary repos to bootstrap a new dev environment:
* env
* installs

To start run create your SSH key and add it to [github](https://github.com/settings/keys)
```bash
ssh-keygen -t rsa -b 4096
```
If you're using separate SSH keys for each service make sure to set up a temporary ssh config:
```
Host github.com
    User git
    HostName github.com
    IdentityFile ~/.ssh/git-hub-id
```

Unlock the SSH key so you don't have to unlock it for every repo:
```bash
ssh-add ~/.ssh/git-hub-id
```

Run the install-env script:
```bash
curl https://raw.githubusercontent.com/casey-k/installs/master/bin/install-env | bash
```

Once all the repos are pulled down, run install-packages:
```bash
cd ~/casey-k/installs/bin
./install-packages
