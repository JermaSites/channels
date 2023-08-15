#!/bin/bash

HEADER_PREFIX="#### "
PLACEHOLDER_TEXT="dynamic-channel-data"
OUTPUT=""

# Convert list of channels into Markdown tables
while read -r LINE; do
    if [[ ${LINE} == ${HEADER_PREFIX}* ]]; then
        echo "Adding header ${LINE}"
        OUTPUT="${OUTPUT}\n${LINE}\n\n"
        OUTPUT="${OUTPUT}| Channel | # Videos | Subscribers | Views |\n| --- | --- | --- | --- |\n"
    else
        IFS=';' read -r -a ARRAY_LINE <<< "${LINE}" # Split line by semi-colon
        echo "Adding channel ${ARRAY_LINE[1]} (${ARRAY_LINE[0]})"
        curl "https://youtube.googleapis.com/youtube/v3/channels?part=statistics,snippet&id=${ARRAY_LINE[0]}&key=${API_KEY}" \
            --header 'Accept: application/json' \
            -fsSL -o output.json

        # Pull channel data out of response if possible
        if [[ $(jq -r '.pageInfo.totalResults' output.json) == 1 ]]; then
            TITLE=$(jq -r '.items[0].snippet.title' output.json)
            URL=$(jq -r '.items[0].snippet.customUrl' output.json)
            VIDEO_COUNT=$(jq -r '.items[0].statistics.videoCount' output.json | numfmt --to=si)
            SUBSCRIBER_COUNT=$(jq -r '.items[0].statistics.subscriberCount' output.json | numfmt --to=si)
            VIEW_COUNT=$(jq -r '.items[0].statistics.viewCount' output.json | numfmt --to=si)
            echo "Added ${TITLE}: ${VIDEO_COUNT} videos (${VIEW_COUNT} views)"
            OUTPUT="${OUTPUT}| ${ARRAY_LINE[2]}[${TITLE}](https://youtube.com/${URL}) | ${VIDEO_COUNT} | ${SUBSCRIBER_COUNT} | ${VIEW_COUNT} |\n"
        else
            echo "Failed! Bad response received: $(<output.json)"
            exit 1
        fi
    fi
done < "${WORKSPACE}/automation/channels.txt"

# Replace placeholder in template with output, updating the README
TEMPLATE_CONTENTS=$(<"${WORKSPACE}/automation/template.md")
echo -e "${TEMPLATE_CONTENTS//${PLACEHOLDER_TEXT}/${OUTPUT}}" > "${WORKSPACE}/README.md"

# Debug
cat "${WORKSPACE}/README.md"