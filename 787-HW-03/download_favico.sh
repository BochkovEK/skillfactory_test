#!/bin/sh

[ -z ${1} ] && { echo "One parameter needed. Example: 'google.com'"; exit 1; }
wget -O ${FAVICONS_DIR}/${1}.favicon.ico ${1}/favicon.ico
