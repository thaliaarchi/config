# Archive Team projects with Docker

## Installing standalone project containers

https://wiki.archiveteam.org/index.php/Running_Archive_Team_Projects_with_Docker#Basic_usage

```sh
docker run --detach --name watchtower \
  --restart=unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --label-enable \
  --cleanup \
  --interval 3600
docker run --detach --name at-terroroftinytown \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=unless-stopped \
  atdr.meo.ws/archiveteam/terroroftinytown-client-grab \
  --concurrent 1 \
  USERNAME
```

## Installing Archive Team Warrior

https://wiki.archiveteam.org/index.php/ArchiveTeam_Warrior#Installing_and_running_with_Docker

```sh
docker run --detach --name archiveteam-warrior \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=unless-stopped \
  --publish 8001:8001 \
  atdr.meo.ws/archiveteam/warrior-dockerfile
```

## Managing containers

```sh
docker start CONTAINER...
docker kill --signal=SIGINT CONTAINER...
docker rm CONTAINER...
```

## Accessing logs

```sh
docker container logs CONTAINER
```

## Selected projects

URLTeam is limited to one item per shortener and IP at a time by the
tracker. I set the concurrency level `--concurrent` to 20 for URLTeam
and 2 for others.

| Wiki                                                                    | Grab script                                                           | Tracker                                                   |
| ----------------------------------------------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------------- |
| [URLTeam](https://wiki.archiveteam.org/index.php/URLTeam)               | [terroroftinytown-client-grab](https://github.com/ArchiveTeam/terroroftinytown-client-grab) | [Tracker](https://tracker.archiveteam.org:1338/) |
| [Reddit](https://wiki.archiveteam.org/index.php/Reddit)                 | [reddit-grab](https://github.com/ArchiveTeam/reddit-grab)             | [Tracker](https://tracker.archiveteam.org/reddit/)        |
| [URLs](https://wiki.archiveteam.org/index.php/URLs)                     | [urls-grab](https://github.com/ArchiveTeam/urls-grab)                 | [Tracker](https://tracker.archiveteam.org/urls/)          |
| [Yahoo! Answers](https://wiki.archiveteam.org/index.php/Yahoo!_Answers) | [yahooanswers-grab](https://github.com/ArchiveTeam/yahooanswers-grab) | [Tracker](https://tracker.archiveteam.org/yahooanswers2/) |
| [Pastebin](https://wiki.archiveteam.org/index.php/Pastebin)             | [pastebin-grab](https://github.com/ArchiveTeam/pastebin-grab)         | [Tracker](https://tracker.archiveteam.org/pastebin/)      |
| [GitHub](https://wiki.archiveteam.org/index.php/GitHub)                 | [github-grab](https://github.com/ArchiveTeam/github-grab)             | [Tracker](https://tracker.archiveteam.org/github/)        |
| [Google Sites](https://wiki.archiveteam.org/index.php/Google_Sites)     | [google-sites-grab](https://github.com/ArchiveTeam/google-sites-grab) | [Tracker](https://tracker.archiveteam.org/google-sites/)  |
| [Flash](https://wiki.archiveteam.org/index.php/Flash)                   | [flashdomains-grab](https://github.com/ArchiveTeam/flashdomains-grab) | [Tracker](https://tracker.archiveteam.org/flashdomains/)  |
| [MediaFire](https://wiki.archiveteam.org/index.php/MediaFire)           | [mediafire-grab](https://github.com/ArchiveTeam/mediafire-grab)       | [Tracker](https://tracker.archiveteam.org/mediafire/)     |
| [Webs](https://wiki.archiveteam.org/index.php/Webs)                     | [webs-grab](https://github.com/ArchiveTeam/webs-grab)                 | [Tracker](https://tracker.archiveteam.org/webs/)          |
| [Periscope](https://wiki.archiveteam.org/index.php/Periscope)           | [periscope-grab](https://github.com/ArchiveTeam/periscope-grab)       | [Tracker](https://tracker.archiveteam.org/periscope/)     |
