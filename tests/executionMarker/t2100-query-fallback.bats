#!/usr/bin/env bats

load canned_config

@test "normal fallback subject is used when subject does not exist" {
    executionMarker --group samples --query notInHere --fallback-subject bar
    run -0 executionMarker --group samples --query notInHere --fallback-subject bar
    assert_output ''
}

@test "normal fallback subject is used for context when subject does not exist" {
    executionMarker --group samples --query notInHere --fallback-subject bar
    run -0 executionMarker --group samples --query notInHere --fallback-subject bar --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "normal fallback subject is used for timestamp when subject does not exist" {
    executionMarker --group samples --query notInHere --fallback-subject bar
    run -0 executionMarker --group samples --query notInHere --fallback-subject bar --get-timestamp
    assert_output '1557046678'
}

@test "generic fallback subject is used for context when subject does not exist" {
    run -0 executionMarker --group samples --query notInHere --fallback-subject '*' --get-context
    assert_output 'Yesterday.'
}

@test "non-existing subject and non-existing fallback subject query fails" {
    run -4 executionMarker --group samples --query notInHere --fallback-subject alsoNotHere
    assert_output ''
}
