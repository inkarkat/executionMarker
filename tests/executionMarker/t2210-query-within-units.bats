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
    run -1 executionMarker --timestamp "$NOW" --group samples --query \* --within 12h
}

@test "fox is within 4 days" {
    executionMarker --timestamp "$NOW" --group samples --query fox --within 4h
}

@test "invalid time unit gives error" {
    run -2 executionMarker --timestamp "$NOW" --group samples --query foo --within 12x
    assert_line -n 0 'ERROR: Invalid TIMESPAN/TIMESLOT: "12x".'
    assert_line -n 2 -e '^Usage:'
}
