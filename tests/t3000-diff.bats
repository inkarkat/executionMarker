#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run executionMarker --timestamp "$NOW" --group samples --diff notInHere
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "diff of foo subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff foo
    [ $status -eq 0 ]
    [ "$output" = '2' ]
}

@test "diff of fallback fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff notInHere --fallback-subject fox
    [ $status -eq 0 ]
    [ "$output" = '133' ]
}
