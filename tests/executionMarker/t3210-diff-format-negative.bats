#!/usr/bin/env bats

load canned_config
readonly NEGATIVE_TIMESTAMP=$((NOW - 140))

@test "%R-formatted negative diff of fox subject is printed" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --format '%R'
    [ $status -eq 0 ]
    [ "$output" = 'in 7 seconds' ]
}

@test "%R-fallback-formatted negative diff of fox subject is printed" {
    RELDATE=doesNotExist run executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --format '%R'
    [ $status -eq 0 ]
    [ "$output" = ' in -7 seconds' ]
}

@test "%p-formatted negative diff of fox subject is printed" {
    run executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --format '%p'
    [ $status -eq 0 ]
    [ "$output" = '7s' ]
}

@test "%s-formatted negative diff of fox subject is printed" {
    run executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --format '%s'
    [ $status -eq 0 ]
    [ "$output" = 'in 7 seconds' ]
}
