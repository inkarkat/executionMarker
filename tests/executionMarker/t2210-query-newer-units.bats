#!/usr/bin/env bats

load canned_config

@test "foo is newer than 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --newer 10s
}

@test "fox is newer than 3 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query fox --newer 3m
}

@test "fox is newer than 12 hours" {
    executionMarker --timestamp "$NOW" --group samples --query fox --newer 12h
}

@test "* is not newer than 12 hours" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query \* --newer 12h
}

@test "fox is newer than 4 days" {
    executionMarker --timestamp "$NOW" --group samples --query fox --newer 4h
}

@test "invalid time unit gives error" {
    run -2 executionMarker --timestamp "$NOW" --group samples --query foo --newer 12x
    assert_line -n 0 'ERROR: Invalid AGE: "12x".'
    assert_line -n 1 -e '^Usage:'
}
