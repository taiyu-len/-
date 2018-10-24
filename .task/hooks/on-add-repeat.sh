#!/bin/bash
############################################################
# Remove annotations from duplicated tasks with REPEAT tag #
############################################################
#~/.task/hooks/on-xxx.yyy \
#   api:2 \
#   args:'task rc:~/mytaskrc list' \
#   command:add \
#   rc:/home/foo/mytaskrc \
#   data:/home/foo/.task \
#   version:2.4.3 \
#   <input.txt \
#   >output.txt
read -r task
has_repeat_tag="any(.tags[]?; .==\"REPEAT\")?"
remove_annotations="del(.annotations)"
if jq -ne "$task|$has_repeat_tag" > /dev/null
then jq -nc "$task|$remove_annotations"
else echo "$task"
fi
