#!/bin/bash

progname=$(basename $0)
VERSION=0.1

cd $(dirname $0)

case $(uname -s) in
FreeBSD)
  type="freebsd"
  nagioslibdir=/usr/local/libexec/nagios
  ;;
Linux)
  type="rpm"
  nagioslibdir=/usr/lib64/nagios/plugins
  ;;
*)
  echo "$progname: unsupported OS $(uname -s)" >&2
  exit 1
esac

if [[ $# -gt 0 ]]; then
  echo "$progname: too many arugments" >&2
  exit 0
fi

fpm -s dir -t $type -n ssh-agent-helper -v $VERSION \
  --maintainer opseng@fxcm.com \
  run-with-agent=/usr/local/bin/ \
  ssh-agent-helper=/usr/local/bin/ \
  check_ssh_key=$nagioslibdir/
