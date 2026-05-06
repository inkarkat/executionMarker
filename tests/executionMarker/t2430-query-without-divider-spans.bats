#!/usr/bin/env bats

load canned_config

@test "foo age is less or equal than 2 minutes" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo -le -2m
}

@test "foo age is less or equal than 1-2 seconds" {
    # actual difference is 2 seconds
    executionMarker --timestamp "$NOW" --group samples --query foo -le -1s
    executionMarker --timestamp "$NOW" --group samples --query foo -le -2s
    ! executionMarker --timestamp "$NOW" --group samples --query foo -le -3s
    ! executionMarker --timestamp "$NOW" --group samples --query foo -le -4s
}

@test "bar age is less or equal than 30, but not 60, 90 seconds" {
    # actual difference is 52 seconds
    executionMarker --timestamp "$NOW" --group samples --query bar -le -30s
    ! executionMarker --timestamp "$NOW" --group samples --query bar -le -60s
    ! executionMarker --timestamp "$NOW" --group samples --query bar -le -90s
}

@test "fox is not older than 180 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox -le -180s
}

@test "* age is less or equal than 2 seconds, minutes, hours, 23 hours but not older than 1, 2, 3, 4 days, 2 weeks" {
    # actual difference is 86246 seconds = 1437 minutes = 24 hours = 1 day = 0.1
    # weeks
    executionMarker --timestamp "$NOW" --group samples --query \* -le -2s
    executionMarker --timestamp "$NOW" --group samples --query \* -le -2m
    executionMarker --timestamp "$NOW" --group samples --query \* -le -2h
    executionMarker --timestamp "$NOW" --group samples --query \* -le -23h
    ! executionMarker --timestamp "$NOW" --group samples --query \* -le -1d
    ! executionMarker --timestamp "$NOW" --group samples --query \* -le -2d
    ! executionMarker --timestamp "$NOW" --group samples --query \* -le -3d
    ! executionMarker --timestamp "$NOW" --group samples --query \* -le -4d
    ! executionMarker --timestamp "$NOW" --group samples --query \* -le -2w
}
