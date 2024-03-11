ARG NODE_TAG="20-bullseye-slim"
FROM node:$NODE_TAG

# renovate: datasource=repology depName=debian_11/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION="20210119"
# renovate: datasource=repology depName=debian_11/curl versioning=loose
ENV CURL_VERSION="7.74.0-1.3+deb11u11"
# renovate: datasource=repology depName=debian_11/fontconfig versioning=loose
ENV FONTCONFIG_VERSION="2.13.1-4.2"
# renovate: datasource=repology depName=debian_11/git versioning=loose
ENV GIT_VERSION="1:2.30.2-1+deb11u2"
# renovate: datasource=repology depName=debian_11/git-lfs versioning=loose
ENV GIT_LFS_VERSION="2.13.2-1+b5"
# renovate: datasource=repology depName=debian_11/gnupg2 versioning=loose
ENV GNUPG2_VERSION="2.2.27-2+deb11u2"
# renovate: datasource=repology depName=debian_11/locales versioning=loose
ENV LOCALES_VERSION="2.31-13+deb11u8"
# renovate: datasource=repology depName=debian_11/procps versioning=loose
ENV PROCPS_VERSION="2:3.3.17-5"
# renovate: datasource=npm depName=eslint
ENV ESLINT_VERSION="8.56.0"
# renovate: datasource=npm depName=pnpm
ENV PNPM_VERSION="8.7.1"

ENV HOME="/root" \
    LC_ALL="en_US.UTF-8" \
    QODANA_DIST="/opt/idea" \
    QODANA_DATA="/data" \
    QODANA_DOCKER="true"
ENV JAVA_HOME="$QODANA_DIST/jbr" \
    QODANA_CONF="$HOME/.config/idea" \
    PATH="$QODANA_DIST/bin:$PATH"

# hadolint ignore=SC2174,DL3009
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    mkdir -m 777 -p /opt $QODANA_DATA $QODANA_CONF && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates=$CA_CERTIFICATES_VERSION \
        curl=$CURL_VERSION \
        fontconfig=$FONTCONFIG_VERSION \
        git=$GIT_VERSION \
        git-lfs=$GIT_LFS_VERSION \
        gnupg2=$GNUPG2_VERSION \
        locales=$LOCALES_VERSION \
        procps=$PROCPS_VERSION && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen && \
    apt-get autoremove -y && apt-get clean && \
    chmod 777 -R $HOME && \
    echo 'root:x:0:0:root:/root:/bin/bash' > /etc/passwd && chmod 666 /etc/passwd && \
    git config --global --add safe.directory '*' && \
    npm install -g eslint@$ESLINT_VERSION pnpm@$PNPM_VERSION && npm config set update-notifier false && \
    chmod 777 -R "$HOME/.npm" "$HOME/.npmrc"

ENV PATH="/opt/yarn/bin:$PATH"