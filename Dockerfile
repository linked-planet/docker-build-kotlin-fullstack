FROM node:14-alpine

# ---------------------------------------------
# INSTALL MISC TOOLS
# ---------------------------------------------
RUN apk add --no-cache --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    "aws-cli" \
    "redis" \
    "git" \
    "git-lfs" \
    "openssh-client" \
    "maven" \
    "curl" \
    "jq" \
    "bash"

# ---------------------------------------------
# INSTALL JDK-11
# ---------------------------------------------

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV JAVA_ALPINE_VERSION 11.0.4

RUN apk add --no-cache \
    "openjdk11-jdk>$JAVA_ALPINE_VERSION" --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community"

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk \
    PATH="/usr/lib/jvm/java-11-openjdk/bin:$PATH"

RUN echo "Testing Java installation" && javac --version

# ---------------------------------------------
# INSTALL GRADLE
# (taken from https://github.com/keeganwitt/docker-gradle/blob/master/jdk11/Dockerfile)
# ---------------------------------------------

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.5.1

ARG GRADLE_DOWNLOAD_SHA256=222a03fcf2fcaf3691767ce9549f78ebd4a77e73f9e23a396899fb70b420cd00
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version

CMD ["gradle"]
