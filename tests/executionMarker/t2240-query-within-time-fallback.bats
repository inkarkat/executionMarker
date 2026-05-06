#!/usr/bin/env bats

load canned_config

@test "fallback subject is used when subject does not exist" {
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --newer 60
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --newer 10
    run -0 executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --newer 60 --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "fallback subject is ignored when subject is newer than 60 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query bar --fallback-subject fox --fallback-on-time --newer 60
    run -0 executionMarker --timestamp "$NOW" --group samples --query bar --fallback-subject fox --fallback-on-time --newer 60 --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "fallback subject is used when subject is not newer than 10 seconds and the fallback is newer" {
    executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --fallback-on-time --newer 10
    run -0 executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --fallback-on-time --newer 10 --get-context
    assert_output 'More foo for me.'
}

@test "original subject context is printed when both subject and fallback subjects are not newer than 10 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject \* --fallback-on-time --newer 10 --get-context
    assert_output 'Two minutes earlier than foo.'
}

@test "original subject context is printed when subject is not newer than but no fallback subject exists" {
    ! executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject notInHere --fallback-on-time --newer 10
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject notInHere --fallback-on-time --newer 10 --get-context
    assert_output 'Two minutes earlier than foo.'
}
