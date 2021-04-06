# Archive Team projects with Docker

https://wiki.archiveteam.org/index.php/Running_Archive_Team_Projects_with_Docker#Basic_usage

```sh
docker run -d --name watchtower \
  --restart=unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --label-enable
docker run -d --name at-terroroftinytown \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=unless-stopped \
  atdr.meo.ws/archiveteam/terroroftinytown-client-grab \
  --concurrent 1 \
  USERNAME
docker kill --signal=SIGINT at-terroroftinytown
docker start watchtower at-terroroftinytown
docker kill --signal=SIGINT at-terroroftinytown
docker rm at-terroroftinytown
```

These are the projects I have installed, with the concurrency levels I
am using:

| Container | `--concurrent` | Grab script | Wiki |
| --------- | -------------- | ----------- | ---- |
| at-terroroftinytown | 20 | [terroroftinytown-client-grab](https://github.com/ArchiveTeam/terroroftinytown-client-grab) | [URLTeam](https://wiki.archiveteam.org/index.php/URLTeam) |
| at-reddit           | 2  | [reddit-grab](https://github.com/ArchiveTeam/reddit-grab) | [Reddit](https://wiki.archiveteam.org/index.php/Reddit) |
| at-urls             | 2  | [urls-grab](https://github.com/ArchiveTeam/urls-grab) | [URLs](https://wiki.archiveteam.org/index.php/URLs) |
| at-pastebin         | 2  | [pastebin-grab](https://github.com/ArchiveTeam/pastebin-grab) | [Pastebin](https://wiki.archiveteam.org/index.php/Pastebin) |
| at-github           | 2  | [github-grab](https://github.com/ArchiveTeam/github-grab) | [GitHub](https://wiki.archiveteam.org/index.php/GitHub) |
| at-flashdomains     | 2  | [flashdomains-grab](https://github.com/ArchiveTeam/flashdomains-grab) | [Flash](https://wiki.archiveteam.org/index.php/Flash) |
