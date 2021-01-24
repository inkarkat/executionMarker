#!/usr/bin/env bats

load canned_config

@test "time cannot be combined with context printing" {
    run executionMarker --timestamp "$NOW" --group samples --time foo --get-context
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot query context with --time." ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "time cannot be combined with timestamp printing" {
    run executionMarker --timestamp "$NOW" --group samples --time foo --get-timestamp
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot query timestamp with --time." ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
