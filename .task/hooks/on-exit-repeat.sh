#!/bin/bash
################################################################
# Tasks with the +REPEAT tag will be restarted upon completion #
################################################################
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
while read task
do
	is_completed=".status == \"completed\""
	has_repeat_tag="any(.tags[]?; .==\"REPEAT\")"
	if jq -ne "($task|$is_completed) and ($task|$has_repeat_tag)" > /dev/null
	then
		uuid="$(jq -rn "$task|.uuid")"
		# Duplicate task
		task "$uuid" duplicate
		# Remove repeat tag from completed operations
		task "$uuid" modify -REPEAT > /dev/null
	fi
done
exit 0
