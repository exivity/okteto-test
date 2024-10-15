#!/bin/sh
set -e

name=$1
namespace=$2
timeout=$3
log_level=$4

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

if [ ! -z $timeout ]; then
params="${params} --timeout=$timeout"
fi

if [ ! -z "$log_level" ]; then
  log_level="--log-level ${log_level}"
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi


echo running: okteto pipeline destroy $log_level --name "${name}" ${params} --wait
okteto test $log_level --name "${name}" ${params} --wait
