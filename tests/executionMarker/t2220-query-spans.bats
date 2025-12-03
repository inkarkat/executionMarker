#!/usr/bin/env bats

load canned_config

@test "foo is within the minute" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within minute
}

@test "fox is not within the minute" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within minute
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
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within minute --get-context
    assert_output 'Two minutes earlier than foo.'
}

@test "invalid timespan gives error" {
    run -2 executionMarker --timestamp "$NOW" --group samples --query foo --within millenium
    assert_line -n 0 'ERROR: Invalid TIMESPAN/TIMESLOT: "millenium".'
    assert_line -n 2 -e '^Usage:'
}
