FROM debian:stable-20250113-slim

LABEL version="0.0.1"
LABEL maintainer="ruipedro16@protonmail.com" 

ARG JASMIN_RELEASE=release-2024.07
ARG JASMIN_URL=https://gitlab.com/jasmin-lang/jasmin # builds faster than github

ARG USER="jasminfmt-user"

SHELL ["/bin/bash", "-c"]

RUN apt-get --quiet --assume-yes update && \
    apt-get --quiet --assume-yes upgrade && \
    apt-get --quiet --assume-yes install apt-utils && \
    apt-get --quiet --assume-yes install \
      sudo wget curl git time xz-utils libicu-dev \
      autoconf debianutils libgmp-dev pkg-config zlib1g-dev \
      vim build-essential python3 python3-pip m4 libgsl-dev \ 
      bash-completion 

RUN apt-get --quiet --assume-yes clean

RUN echo "%sudo  ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers && \
    chown root:root /etc/sudoers.d/sudoers && \
    chmod 0400 /etc/sudoers.d/sudoers && \
    useradd --create-home --shell /bin/bash --home-dir /home/$USER --user-group --groups sudo --uid 1001 $USER

USER $USER
WORKDIR /home/$USER

RUN curl -L https://nixos.org/nix/install > nix-install && sh nix-install

RUN git clone ${JASMIN_URL} && \
    cd jasmin && \
    git checkout ${JASMIN_RELEASE} && \
    USER=$USER source /home/$USER/.nix-profile/etc/profile.d/nix.sh && \
    nix-channel --update && \ 
    nix-shell --command "(cd compiler && make clean && make CIL && make)" && \
    sudo install -D compiler/jasmin* /usr/local/bin/

COPY --chown=$USER:$USER . /home/$USER/jasminfmt
WORKDIR /home/$USER/jasminfmt

CMD ["/bin/bash", "--login"]
