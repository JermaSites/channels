HEADER_PREFIX="#### "
OUTPUT=""
while read line; do
    if [[ $line == $HEADER_PREFIX* ]]; then
    echo "Adding header $line"
    OUTPUT="$OUTPUT\n$line\n\n"
    OUTPUT="$OUTPUT| Channel | # Videos | Subscribers | Views |\n| --- | --- | --- | --- |\n"
    else
    ARRAY_LINE=(${line//;/ })
    echo "Adding channel ${ARRAY_LINE[1]}"
    curl "https://youtube.googleapis.com/youtube/v3/channels?part=statistics,snippet&id=${ARRAY_LINE[0]}&key=$API_KEY" \
        --header 'Accept: application/json' \
        --silent \
        -o output.json

    # Pull channel data out of response
    TITLE=$(jq -r '.items[0].snippet.title' output.json)
    URL=$(jq -r '.items[0].snippet.customUrl' output.json)
    VIDEO_COUNT=$(jq -r '.items[0].statistics.videoCount' output.json)
    SUBSCRIBER_COUNT=$((($(jq -r '.items[0].statistics.subscriberCount' output.json)+999)/1000))
    VIEW_COUNT=$((($(jq -r '.items[0].statistics.viewCount' output.json)+999999)/1000000))
    echo "$TITLE: $VIDEO_COUNT videos (${VIEW_COUNT}M views)"
    OUTPUT="$OUTPUT| ${ARRAY_LINE[2]}[$TITLE](https://youtube.com/$URL) | $VIDEO_COUNT | ${SUBSCRIBER_COUNT}K | ${VIEW_COUNT}M |\n"
    fi
done < $WORKSPACE/automation/channels.txt

echo "$OUTPUT" > temp.md
templ=$(<$WORKSPACE/automation/template.md)
value=$(<$WORKSPACE/temp.md)
echo -e "${templ//dynamic-channel-data/$value}" > $WORKSPACE/README.md
cat $WORKSPACE/README.md