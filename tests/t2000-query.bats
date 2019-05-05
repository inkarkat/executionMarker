#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run executionMarker --group samples --query notInHere
    [ $status -eq 1 ]
    [ -z "$output" ]
}

@test "existing subject can be queried" {
    run executionMarker --group samples --query foo
    [ $status -eq 0 ]
    [ -z "$output" ]
}

@test "context of existing subject can be queried" {
    run executionMarker --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}
