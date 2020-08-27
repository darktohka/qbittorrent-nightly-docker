FROM alpine:latest

ENV SHELL=/bin/sh

ENV PEER_PORT=6881 \
    WEB_PORT=8080 \
    UID=1000 \
    GID=1000

WORKDIR /tmp

RUN \
    apk update \
# Install runtime libraries
    && apk add --no-cache libressl libgcrypt libstdc++ qt5-qtbase geoip su-exec \
# Install development tools
    && apk add --no-cache --virtual .dev-deps git cmake clang gcc g++ musl-dev libgcrypt-dev libressl-dev linux-headers boost-dev qt5-qtbase-dev qt5-qttools-dev geoip-dev ninja \
# Build libtorrent
    && git clone --depth=1 https://github.com/arvidn/libtorrent \
    && mkdir -p libtorrent/build \
    && cd libtorrent/build \
    && cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_BUILD_TYPE=Release .. \
    && ninja -j$(nproc) \
    && ninja install \
# Download qBittorrent
    && cd /tmp \
    && rm -rf /tmp/* \
    && git clone --depth=1 https://github.com/qBittorrent/qBittorrent \
    && mkdir -p qBittorrent/build \
    && cd qBittorrent \
# Remove alpha status from build (some trackers disallow it)
    && sed -i "s|VER_STATUS.*=.*|VER_STATUS =|i" version.pri \
# Build qBittorrent
    && cd build \
    && cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DSYSTEM_QTSINGLEAPPLICATION=ON -DGUI=OFF -DSTACKTRACE=OFF .. \
    && ninja -j$(nproc) \
    && ninja install \
# Cleanup
    && apk del .dev-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/include/* /usr/share/icons/* /usr/lib/cmake /usr/share/cmake

COPY rootfs /

EXPOSE ${PEER_PORT} ${PEER_PORT}/udp ${WEB_PORT}
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/qbittorrent-nox"]