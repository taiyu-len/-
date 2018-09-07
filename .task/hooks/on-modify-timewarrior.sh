#!/bin/bash
#~/.task/hooks/on-xxx.yyy \
#   api:2 \
#   args:'task rc:~/mytaskrc list' \
#   command:add \
#   rc:/home/foo/mytaskrc \
#   data:/home/foo/.task \
#   version:2.4.3 \
#   <input.txt \
#   >output.txt

# shellcheck disable=SC2034
# Read arguments.
{
    api="${1#api:}"
   args="${2#args:}"
    cmd="${3#command:}"
     ec="${4#rc:}"
   data="${5#data:}"
version="${6#version:}"

read -r before
read -r after
}
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
query='.description//"", .project//"",
(.annotations[]?|select(.entry == '"$start_time"').description)'
# extract json info
{
read -r desc
read -r proj
read -r anno
} < <(jq -nr "$after|$query")

timew "$timew_cmd" ${desc:+"$desc"} ${proj:+"$proj"} ${anno:+"$anno"} :yes
exit 0
