#!/bin/sh
set -ue

export PATH="local/bin:$PATH"
export BASE_DIR=$(cd $(dirname $0); pwd)
export PLENV_VERSION=`cat $BASE_DIR/.perl-version`

export PERL5LIB="$BASE_DIR/local/lib/perl5:$BASE_DIR/lib"
export LANG="C";
export DATA_DIR="t/data"

if [ $# -gt 0 ]; then
  forkprove -vr $1
else
  forkprove -r ./t
fi
