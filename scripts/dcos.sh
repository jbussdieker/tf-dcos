#!/bin/bash
TYPE=$1
shift
HOSTNAME=$1
shift
BOOTSTRAP_URL=$1

sudo hostname ${HOSTNAME}

# Setup master
curl -s -O http://${BOOTSTRAP_URL}/dcos_install.sh

sudo bash dcos_install.sh ${TYPE}
