# Change hostname

```sh
hostnamectl
sudo hostnamectl set-hostname newname
```

Add `127.0.0.1 newname` to hosts:

```sh
sudo vim /etc/hosts
```

In cloud-init settings, set `preserve_hostname: true`:

```sh
sudo vim /etc/cloud/cloud.cfg
```

See changes:

```sh
hostnamectl
```
