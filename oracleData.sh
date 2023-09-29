#!/bin/bash
source .env

set -o errexit
set -o nounset

AssertionSettled="0xf4fa324b13daeb4e1aae736c2553632ae0fb16fb31f2d4da8ac99fd056313a13"
AssertionDisputed="0x60133788b013c89f2a3756dbc47e3484997b87bd7e0af98a7d70232032c1ce2b"
AssertionMade="0xdb1513f0abeb57a364db56aa3eb52015cca5268f00fd67bc73aaf22bccab02b7"

echo "Getting state of the oracle..."

for methodId in "$AssertionSettled" "$AssertionDisputed" "$AssertionMade"
do
  
  MethodName=(${!methodId@})
  OracleStateLog="./oracle_events/${MethodName}.json"

  cast logs --json \
   --rpc-url $ETH_RPC_URL \
   --from-block $FROM_BLOCK \
   --address $OOV3 \
   --to-block latest \
   $methodId \
   > $OracleStateLog

done

echo "Validating the oracle output..."

node --no-warnings getOracleState.js 

rm -rf $OracleStateLog

echo "done!"