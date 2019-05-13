#!/usr/bin/env bats

load canned_config

@test "foo is within 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within 10s
}

@test "fox is within 3 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query fox --within 3m
}

@test "fox is within 12 hours" {
    executionMarker --timestamp "$NOW" --group samples --query fox --within 12h
}

@test "* is not within 12 hours" {
    run executionMarker --timestamp "$NOW" --group samples --query \* --within 12h
    [ $status -eq 1 ]
}

@test "fox is within 4 days" {
    executionMarker --timestamp "$NOW" --group samples --query fox --within 4h
}

@test "invalid time unit gives error" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --within 12x
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Invalid TIMESPAN/TIMESLOT: "12x".' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
