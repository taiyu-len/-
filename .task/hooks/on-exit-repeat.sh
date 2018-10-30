#!/bin/bash
################################################################
# Tasks with the +REPEAT tag will be restarted upon completion #
################################################################
while read task
do
	is_completed='.status == "completed"'
	has_repeat_tag='any(.tags[]?; . == "REPEAT")'
	if jq -ne "$task | ($is_completed and $has_repeat_tag)" > /dev/null
	then
		uuid="$(jq -rn "$task|.uuid")"
		# Duplicate task
		task "$uuid" duplicate
		# Remove repeat tag from completed operations
		task "$uuid" modify -REPEAT > /dev/null
	fi
done
exit 0
