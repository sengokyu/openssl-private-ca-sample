#!/usr/bin/env bash

set -u

make_files()
{
  local dir
  dir=$1

  mkdir -p ${dir}/crl ${dir}/newcerts ${dir}/private ${dir}/var
  echo '01' > ${dir}/var/serial
  echo '01' > ${dir}/var/crlnumber
  touch ${dir}/var/index.txt
}

make_cert()
{
  local dir
  dir=$1

  if [ \! -f openssl-req.cnf ]; then
    echo At first, create openssl-req.cnf file.
    exit 1
  fi

  openssl req \
    -config openssl-req.cnf \
    -x509 \
    -nodes \
    -newkey EC \
    -pkeyopt ec_paramgen_curve:prime256v1 \
    -days 3650 \
    -out ${dir}/cacert.pem \
    -keyout ${dir}/private/cakey.pem
}

make_files demoCA
make_cert demoCA

