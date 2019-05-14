#!/usr/bin/env bats

load canned_config

@test "foo is without every 2 minutes" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo --without 'every 2 minutes'
}

@test "foo is without every 1-2 seconds" {
    # actual difference is 2 seconds
    executionMarker --timestamp "$NOW" --group samples --query foo --without 'every 1 seconds'
    executionMarker --timestamp "$NOW" --group samples --query foo --without 'every 2 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query foo --without 'every 3 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query foo --without 'every 4 seconds'
}

@test "bar is without every 30, but not 60, 90 seconds" {
    # actual difference is 52 seconds
    executionMarker --timestamp "$NOW" --group samples --query bar --without 'every 30 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query bar --without 'every 60 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query bar --without 'every 90 seconds'
}

@test "fox is not without every 180 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --without 'every 180 seconds'
    [ $status -eq 1 ]
}

@test "* is without every 2 seconds, minutes, hours, 1 days, but not without every 2, 3, 4 days, 2 weeks" {
    # actual difference is 86246 seconds = 1437 minutes = 24 hours = 1 day = 0.1
    # weeks
    executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 2 seconds'
    executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 2 minutes'
    executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 2 hours'
    executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 1 days'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 2 days'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 3 days'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 4 days'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --without 'every 2 weeks'
}
