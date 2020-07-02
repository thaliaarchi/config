# SSH Notes

## Remove remote key from `known_hosts`

When the host key changes on the remote host, the `known_hosts` file
blocks ssh connections to that host as there may be a man-in-the-middle
attack.

```sh
ssh-keygen -R 192.168.1.45
```
