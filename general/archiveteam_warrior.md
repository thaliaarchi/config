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
```
