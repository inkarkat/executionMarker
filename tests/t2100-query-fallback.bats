#!/usr/bin/env bats

load canned_config

@test "normal fallback subject is used when subject does not exist" {
    executionMarker --group samples --query notInHere --fallback-subject bar
    run executionMarker --group samples --query notInHere --fallback-subject bar --get-context
    [ $status -eq 0 ]
    [ "$output" = 'Less than a minute earlier than foo.' ]
}

@test "generic fallback subject is used when subject does not exist" {
    run executionMarker --group samples --query notInHere --fallback-subject '*' --get-context
    [ $status -eq 0 ]
    [ "$output" = 'Yesterday.' ]
}

@test "non-existing subject and non-existing fallback subject query fails" {
    run executionMarker --group samples --query notInHere --fallback-subject alsoNotHere
    [ $status -eq 1 ]
    [ -z "$output" ]
}
