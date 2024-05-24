#!/usr/bin/env bats

load canned_config

@test "foo is within the minute" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within minute
}

@test "fox is not within the minute" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --within minute
    [ $status -eq 1 ]
}

@test "* is not within the second, minute, hour, day, but within the week, month, year" {
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within second
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within minute
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within hour
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within day
    executionMarker --timestamp "$NOW" --group samples --query \* --within week
    executionMarker --timestamp "$NOW" --group samples --query \* --within month
    executionMarker --timestamp "$NOW" --group samples --query \* --within year
}

@test "context of fox that is not within the minute is printed, too" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --within minute --get-context
    [ $status -eq 1 ]
    [ "$output" = "Two minutes earlier than foo." ]
}

@test "invalid timespan gives error" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --within millenium
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Invalid TIMESPAN/TIMESLOT: "millenium".' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
