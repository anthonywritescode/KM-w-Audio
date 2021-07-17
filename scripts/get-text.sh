#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: $0 FILENAME" 1>&2
    exit 1
fi

azurelocation=westus2
subscriptionKey="$AZURE_SUBSCRIPTION_KEY"
filename="$1"
output_format="simple"
language="en-US"
locale="en-US"
recognition_mode="conversation"

token="$(
    curl \
        --silent \
        --fail \
        -X POST \
        -H "Content-type: application/x-www-form-urlencoded" \
        -H "Content-Length: 0" \
        -H "Ocp-Apim-Subscription-Key: $subscriptionKey" \
        "https://$azurelocation.api.cognitive.microsoft.com/sts/v1.0/issuetoken"
)"

if [ -z "$token" ]; then
    echo "Request to issue an auth token failed." && exit 1;
fi

request_url="https://$azurelocation.stt.speech.microsoft.com/speech/recognition/$recognition_mode"
request_url+="/cognitiveservices/v1?language=$language&locale=$locale"
request_url+="&format=$output_format&requestid=rest_sample_request_id"

curl \
    --silent \
    --fail \
    --limit-rate 1m \
    -X POST \
    -H "Transfer-Encoding: chunked" \
    -H 'Content-type: audio/wav; codec="audio/pcm"; samplerate=16000' \
    -H "Authorization: Bearer $token" \
    --data-binary "@$filename" \
    "$request_url"
