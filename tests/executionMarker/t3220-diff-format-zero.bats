#!/usr/bin/env bats

load canned_config
readonly ZERO_TIMESTAMP=$((NOW - 133))

@test "%R-formatted zero diff of fox subject is printed" {
    run executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%R'
    [ $status -eq 0 ]
    [ "$output" = 'no time' ]
}

@test "%p-formatted zero diff of fox subject is printed" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%p'
    [ $status -eq 0 ]
    [ "$output" = 'no time' ]
}

@test "%s-formatted zero diff of fox subject is printed" {
    run executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%s'
    [ $status -eq 0 ]
    [ "$output" = 'just now' ]
}
