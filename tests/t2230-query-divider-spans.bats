#!/usr/bin/env bats

load canned_config

@test "foo is within every 2 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within 'every 2 minutes'
}

@test "foo is within every 3+ seconds" {
    # actual difference is 2 seconds
    ! executionMarker --timestamp "$NOW" --group samples --query foo --within 'every 1 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query foo --within 'every 2 seconds'
    executionMarker --timestamp "$NOW" --group samples --query foo --within 'every 3 seconds'
    executionMarker --timestamp "$NOW" --group samples --query foo --within 'every 4 seconds'
}

@test "bar is within every 60, 90, but not 30 seconds" {
    # actual difference is 52 seconds
    ! executionMarker --timestamp "$NOW" --group samples --query bar --within 'every 30 seconds'
    executionMarker --timestamp "$NOW" --group samples --query bar --within 'every 60 seconds'
    executionMarker --timestamp "$NOW" --group samples --query bar --within 'every 90 seconds'
}

@test "fox is not within every 90 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --within 'every 90 seconds'
    [ $status -eq 1 ]
}

@test "* is not within every 2 seconds, minutes, hours, 1 days, but within every 2, 3, 4 days, 2 weeks" {
    # actual difference is 86246 seconds = 1437 minutes = 24 hours = 1 day = 0.1
    # weeks
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 2 seconds'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 2 minutes'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 2 hours'
    ! executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 1 days'
    executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 2 days'
    executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 3 days'
    executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 4 days'
    executionMarker --timestamp "$NOW" --group samples --query \* --within 'every 2 weeks'
}
