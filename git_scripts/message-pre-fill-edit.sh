#!/bin/bash

message=${1:-""}
curr_branch_name=$(git branch --show-current)
branch_type=$(echo $curr_branch_name | cut -d '-' -f1)
ticket_proj=$(echo $curr_branch_name | cut -d '-' -f2)
ticket_num=$(echo $curr_branch_name | cut -d '-' -f3)
message_prefix="$branch_type: $ticket_proj-$ticket_num"

git commit -em "$message_prefix $message"
