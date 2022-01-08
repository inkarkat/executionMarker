#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run executionMarker --group samples --query notInHere
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "existing subject can be queried" {
    run executionMarker --group samples --query foo
    [ $status -eq 0 ]
    [ -z "$output" ]
}

@test "non-existing subject query of context fails" {
    run executionMarker --group samples --query notInHere --get-context
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "context of existing subject can be queried" {
    run executionMarker --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}

@test "non-existing subject query of timestamp fails" {
    run executionMarker --group samples --query notInHere --get-timestamp
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "timestamp of existing subject can be queried" {
    run executionMarker --group samples --query foo --get-timestamp
    [ $status -eq 0 ]
    [ "$output" = '1557046728' ]
}

@test "context and timestamp of existing subject can be queried" {
    run executionMarker --group samples --query foo --get-timestamp --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.
1557046728' ]
}
