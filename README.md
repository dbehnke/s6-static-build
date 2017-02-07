# s6-static-build

Upstream: http://skarnet.org/software/s6/

This project builds portable binaries (thanks to docker, musl, alpine linux)

Docker: http://docker.io

Musl: https://www.musl-libc.org/

Alpine: https://alpinelinux.org/

## What is S6?

From the author's website:

s6 is a small suite of programs for UNIX, designed to allow process supervision (a.k.a service supervision), in the line of daemontools and runit, as well as various operations on processes and daemons. It is meant to be a toolbox for low-level process and service administration, providing different sets of independent tools that can be used within or without the framework, and that can be assembled together to achieve powerful functionality with a very small amount of code.

## Quickstart

1. Install Docker

2. run make

3. If all goes well you'll have a s6-binaries-{version}.tar.gz with all the statically built binaries

