#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run executionMarker --group samples --query notInHere
    [ $status -eq 1 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "existing subject can be queried" {
    run executionMarker --group samples --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "context of existing subject can be queried" {
    run executionMarker --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'More foo for me.' ]
}
