#!/bin/bash

# default to using Org1
LANGUAGE="javascript"

# Exit on first error, print all commands.
set -e
set -o pipefail

. test-network/scripts/utils.sh

# Where am I?
DIR=$(cd "$(dirname "$0")" && pwd)

function run_tocken_erc721_javascript() {
    
    cd test-network
    
    ./start_token_erc721_javascript.sh
    
    cd ../python-script

    python3 update_YAML.py

    cd ../../caliper-workspace

    npx caliper bind --caliper-bind-sut fabric:2.2

    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myNFTBenchmark.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled


    cd ${DIR}
}

function run_tocken_erc721_java() {
    
    test-network/start_token_erc721_java.sh
    
    python3 python-script/update_YAML.py

    cd ../caliper-workspace

    npx caliper bind --caliper-bind-sut fabric:2.2

    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myNFTBenchmark.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled

    cd ${DIR}
}

function run_tocken_erc721_go() {
    
    test-network/start_token_erc721_go.sh
    
    python3 python-script/update_YAML.py

    cd ../caliper-workspace

    npx caliper bind --caliper-bind-sut fabric:2.2

    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myNFTBenchmark.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled

    cd ${DIR}
}

function run_tocken_erc721_java_ccas() {
    
    test-network/start_token_erc721_java_ccas.sh
    
    python3 python-script/update_YAML.py

    cd ../caliper-workspace

    npx caliper bind --caliper-bind-sut fabric:2.2

    npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/networkConfig.yaml --caliper-benchconfig benchmarks/myNFTBenchmark.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled

    cd ${DIR}
}

# parse flags

while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  -h )
    printHelp $MODE
    exit 0
    ;;
  -l )
    LANGUAGE="$2"
    shift
    ;;
  * )
    errorln "Unknown flag: $key"
    printHelp
    exit 1
    ;;
  esac
  shift
done

if [[ "$LANGUAGE" == "javascript" ]]; then

    infoln "Running workload for Javascript on tocken_erc721"

    run_tocken_erc721_javascript

elif [[ "$LANGUAGE" == "java" ]]; then

    infoln "Running workload for Java on tocken_erc721"

    run_tocken_erc721_java


elif [[ "$LANGUAGE" == "go" ]]; then

    infoln "Running workload for go on tocken_erc721"

    run_tocken_erc721_go


elif [[ "$LANGUAGE" == "java_ccas" ]]; then

    infoln "Running workload for Java - chaincode as a services on tocken_erc721"

    run_tocken_erc721_java_ccas

fi