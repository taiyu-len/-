#!/bin/bash
###############################################################################
# Tasks with the repeat attribute will be restarted upon completion And wait
# until the specified time.
###############################################################################
# Useful for tasks that should be repeated upon completion, but not as strictly
# as recurring tasks. use recurring for strictly repeating tasks.
###############################################################################
set -o errexit
while read task
do
	is_completed='.status == "completed"'
	has_repeat='has("repeat")'
	if jq -ne "$task | ($is_completed and $has_repeat)" > /dev/null
	then
		uuid="$(jq -rn "$task|.uuid")"
		delay="$(jq -rn "$task|.repeat")"
		task "$uuid" duplicate "wait:$delay"
		task "$uuid" modify repeat: > /dev/null
	fi
done
exit 0
