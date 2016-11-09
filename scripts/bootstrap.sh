#!/bin/bash
HOSTNAME=$1
shift
CLUSTER_NAME=$1
shift
IP=$(curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4)
MASTERS=$(echo $@ | xargs -n 1 | awk '{print "- " $1}')

sudo hostname ${HOSTNAME}

mkdir -p genconf

cat >genconf/config.yaml <<EOS
---
bootstrap_url: http://${IP}
cluster_name: '${CLUSTER_NAME}'
dns_search: ${CLUSTER_NAME}.local
exhibitor_storage_backend: static
ip_detect_filename: /genconf/ip-detect
master_discovery: static
resolvers:
- 10.0.0.2
master_list:
${MASTERS}
EOS

cat >genconf/ip-detect <<EOS
#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
EOS

[ -f dcos_generate_config.sh ] || curl -s -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh

sudo bash dcos_generate_config.sh

if ! lsof -i:80; then
  sudo docker run -d -p 80:80 -v ${PWD}/genconf/serve:/usr/share/nginx/html:ro nginx
fi
