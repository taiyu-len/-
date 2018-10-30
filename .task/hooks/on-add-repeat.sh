#!/usr/bin/env bash
############################################################
# Remove annotations from duplicated tasks with REPEAT tag #
############################################################
exec jq -cM "$(cat <<SCRIPT
if any(.tags[]?; . == "REPEAT")
then del(.annotations)
else .
end
SCRIPT
)"
