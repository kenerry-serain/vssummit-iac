#!/bin/bash
DOCKER_DAEMON_DIR="/home/admin/cri-dockerd";
#  DOCKER_DAEMON_DIR="/tmp/cri-dockerd";

cloneDockerDaemonRepository(){
    if [ ! -d "${DOCKER_DAEMON_DIR}" ] 
    then
        git clone https://github.com/Mirantis/cri-dockerd.git;
    fi

    cd "${DOCKER_DAEMON_DIR}";
}

installGo(){
    mkdir -p bin

    if [ ! -f "${DOCKER_DAEMON_DIR}/installer_linux" ] 
    then
        wget https://storage.googleapis.com/golang/getgo/installer_linux;
    fi

    chmod +x ./installer_linux;
    ./installer_linux;
    source ~/.bash_profile;
}

buildDockerDaemonBinary(){
    local version=$((git describe --abbrev=0 --tags | sed -e 's/v//') || echo $(cat version)-$(git log -1 --pretty='%h')) 
    local prerelease=$(grep -q dev <<< "${version}" && echo "pre" || echo "") 
    local revision=$(git log -1 --pretty='%h')

    go build -ldflags="-X github.com/Mirantis/cri-dockerd/version.Version='${version}}' -X github.com/Mirantis/cri-dockerd/version.PreRelease='${prerelease}' -X github.com/Mirantis/cri-dockerd/version.BuildTime='$BUILD_DATE' -X github.com/Mirantis/cri-dockerd/version.GitCommit='${revision}'" -o cri-dockerd
    go build -o bin/cri-dockerd
}

installDockerDaemon(){
    mkdir -p /usr/local/bin
    install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
    cp -a packaging/systemd/* /etc/systemd/system
    sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
}

initDockerCriServices(){
    systemctl daemon-reload
    systemctl enable cri-docker.service
    systemctl enable --now cri-docker.socket
}

cloneDockerDaemonRepository
installGo
buildDockerDaemonBinary
installDockerDaemon
initDockerCriServices