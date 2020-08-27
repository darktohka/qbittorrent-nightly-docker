![](https://img.shields.io/docker/stars/darktohka/qbittorrent-nightly.svg) ![](https://img.shields.io/docker/pulls/darktohka/qbittorrent-nightly.svg)

# Environment variables:
| Environment | Default value |
|-------------|---------------|
| PEER_PORT   | 6881          |
| WEB_PORT    | 8080          |
| UID         | 1000          |
| GID         | 1000          |

# Default username & password
- username: admin
- password: adminadmin

# Volumes
- /data - qBittorrent configuration and data

# Deploying
## Terminal

```bash
docker run -d \
    --name qbittorrent \
    -e UID=1000 \
    -e GID=1000 \
    -e PEER_PORT=6881 \
    -e WEB_PORT=8080 \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -p 8080:8080 \
    -v $(PWD)/data:/data
    --restart unless-stopped
    darktohka/qbittorrent-nightly
```

## Docker-compose
```yml
qbittorrent:
    image: darktohka/qbittorrent-nightly
    ports:
    - "8080:8080"
    - "6881:6881"
    - "6881:6881/udp"
    volumes:
    - $(PWD)/data:/data
    environment:
    - UID=1000
    - GID=1000
    - PEER_PORT=6881
    - WEB_PORT=8080
    restart: unless-stopped
```