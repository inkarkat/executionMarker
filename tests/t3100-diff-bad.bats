#!/usr/bin/env bats

load canned_config

@test "diff cannot be combined with context printing" {
    run executionMarker --timestamp "$NOW" --group samples --diff foo --get-context
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot query additional information with --diff; use --query instead." ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "diff cannot be combined with timestamp printing" {
    run executionMarker --timestamp "$NOW" --group samples --diff foo --get-timestamp
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot query additional information with --diff; use --query instead." ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
