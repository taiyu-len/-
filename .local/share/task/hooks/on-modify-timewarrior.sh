#!/bin/bash
#########################################
# Tasks will be tracked via timewarrior #
#########################################
read -r before
read -r after

# Dont modify task
echo "$after"

# Check what whether we are stopping or starting
if jq -ne "$before|has(\"start\") and ($after|has(\"start\")|not)"
then
	timew_cmd="stop"
	start_time="$(jq -n "$before|.start")"
elif jq -ne "$after|has(\"start\") and ($before|has(\"start\")|not)"
then
	timew_cmd="start"
	start_time="$(jq -n "$after|.start")"
else exit 0
fi > /dev/null

# shellcheck disable=SC2016
# Query json
query="$(cat <<SCRIPT
.description//"",
.project//"",
(.annotations[]? | select(.entry == $start_time).description)
SCRIPT
)"
# extract json info
{
read -r desc
read -r proj
read -r anno
} < <(jq -nr "$after|$query")

timew "$timew_cmd" ${desc:+"$desc"} ${proj:+"$proj"} ${anno:+"$anno"} :yes
exit 0
