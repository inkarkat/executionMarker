#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run executionMarker --timestamp "$NOW" --group samples --time notInHere
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "time of foo subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --time foo
    [ $status -eq 0 ]
    [ "$output" = '1557046728' ]
}

@test "time of fallback fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --time notInHere --fallback-subject fox
    [ $status -eq 0 ]
    [ "$output" = '1557046597' ]
}
