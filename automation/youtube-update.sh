#!/bin/bash

channels_file="${WORKSPACE}/automation/channels.txt"
template_file="${WORKSPACE}/automation/template.md"
output_file="${WORKSPACE}/README.md"

header_prefix="#### "
placeholder_text="dynamic-channel-data"
temp_output_file="output.json"
output=""

# Convert list of channels into Markdown tables
while read -r line; do
    if [[ ${line} == ${header_prefix}* ]]; then
        echo "Adding header ${line}"
        output="${output}\n${line}\n\n"
        output="${output}| Channel ↕ | # Videos ↕ | Subscribers ↕ | Views ↕ |\n| --- | --- | --- | --- |\n"
    else
        IFS=';' read -r channel_id channel_name emoji <<< "${line}" # Split line by semi-colon
        echo "Adding channel ${channel_name} (${channel_id})"
        curl "https://youtube.googleapis.com/youtube/v3/channels?part=statistics,snippet&id=${channel_id}&key=${API_KEY}" \
            --header 'Accept: application/json' \
            -fsSL -o ${temp_output_file}

        # Pull channel data out of response if possible
        if [[ $(jq -r '.pageInfo.totalResults' output.json) == 1 ]]; then
            jq_fields=(
                '.items[0].snippet.title'
                '.items[0].snippet.customUrl'
                '.items[0].statistics.videoCount'
                '.items[0].statistics.subscriberCount'
                '.items[0].statistics.viewCount'
            )
            {
                read -r title
                read -r url
                read -r video_count
                read -r subscriber_count
                read -r view_count
            } < <(IFS=','; jq -r "${jq_fields[*]}" < ${temp_output_file})

            video_count=$(numfmt --to=si "${video_count}" | tr G B)
            subscriber_count=$(numfmt --to=si "${subscriber_count}" | tr G B)
            view_count=$(numfmt --to=si "${view_count}" | tr G B)
            echo "Added ${title}: ${video_count} videos (${view_count} views)"
            output="${output}| ${emoji}[${title}](https://youtube.com/${url}) | ${video_count} | ${subscriber_count} | ${view_count} |\n"
        else
            echo "Failed! Bad response received: $(<${temp_output_file})"
            exit 1
        fi
    fi
done < ${channels_file}

# Replace placeholder in template with output, updating the README
template_contents=$(<${template_file})
echo -e "${template_contents//${placeholder_text}/${output}}" > ${output_file}

# Debug
cat "${WORKSPACE}/README.md"
