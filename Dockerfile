FROM archlinux as builder
MAINTAINER Karl Hepworth

RUN mkdir /app
COPY . /app

# Prepare system
RUN pacman -Syu --noconfirm
RUN pacman --noconfirm -Sy base-devel
RUN pacman --noconfirm -Sy git go-pie

RUN mkdir /go
RUN chmod -R 777 /go
RUN mkdir /.cache
RUN chmod -R 777 /.cache

# Build application
RUN chmod -R 777 /app
RUN cd /app/pygmy-go-bin && \
    sudo -u nobody makepkg
RUN cd /app/pygmy-go-git && \
    sudo -u nobody makepkg -Si

# Produce result
FROM archlinux
COPY --from=builder /app /app
WORKDIR /app