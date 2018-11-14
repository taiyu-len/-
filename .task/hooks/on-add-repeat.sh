#!/usr/bin/env bash
############################################################
# Remove annotations from duplicated tasks with REPEAT tag #
############################################################
exec jq -cM '
if has("repeat")
then del(.annotations)
else .
end'
