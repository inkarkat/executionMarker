#!/usr/bin/env bats

load canned_config

@test "foo is newer than 2 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query foo --newer 2m
}

@test "foo is newer than 3+ seconds" {
    # actual difference is 2 seconds
    ! executionMarker --timestamp "$NOW" --group samples --query foo --newer 1s
    ! executionMarker --timestamp "$NOW" --group samples --query foo --newer 2s
    executionMarker --timestamp "$NOW" --group samples --query foo --newer 3s
    executionMarker --timestamp "$NOW" --group samples --query foo --newer 4s
}

@test "bar is newer than 60, 90, but not 30 seconds" {
    # actual difference is 52 seconds
    ! executionMarker --timestamp "$NOW" --group samples --query bar --newer 30s
    executionMarker --timestamp "$NOW" --group samples --query bar --newer 60s
    executionMarker --timestamp "$NOW" --group samples --query bar --newer 90s
}

@test "fox is not newer than 90 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --newer 90s
}

@test "* is not newer than 2 seconds, minutes, hours, 1 days, but newer than 2, 3, 4 days, 2 weeks" {
    # actual difference is 86246 seconds = 1437 minutes = 24 hours = 1 day = 0.1
    # weeks
    ! executionMarker --timestamp "$NOW" --group samples --query \* --newer 2s
    ! executionMarker --timestamp "$NOW" --group samples --query \* --newer 2m
    ! executionMarker --timestamp "$NOW" --group samples --query \* --newer 2h
    ! executionMarker --timestamp "$NOW" --group samples --query \* --newer 1d
    executionMarker --timestamp "$NOW" --group samples --query \* --newer 2d
    executionMarker --timestamp "$NOW" --group samples --query \* --newer 3d
    executionMarker --timestamp "$NOW" --group samples --query \* --newer 4d
    executionMarker --timestamp "$NOW" --group samples --query \* --newer 2w
}
