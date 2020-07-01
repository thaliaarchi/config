# Change hostname

```sh
hostnamectl
sudo hostnamectl set-hostname newname
sudo hostnamectl set-hostname --pretty "New Name"
```

Add the hostname to hosts:

```sh
echo '127.0.0.1 newname' | sudo tee /etc/hosts
```

In cloud-init settings, enable `preserve_hostname`:

```sh
sudo sed -i.bak 's/^preserve_hostname: false$/preserve_hostname: true/g' /etc/cloud/cloud.cfg
```

See changes:

```sh
hostnamectl
```
