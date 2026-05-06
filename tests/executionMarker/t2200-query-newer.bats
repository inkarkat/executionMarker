#!/usr/bin/env bats

load canned_config

@test "non-existing group query for --newer fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group doesNotExist --query notInHere --newer 10
    assert_output ''
}

@test "non-existing subject query for --newer fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group samples --query notInHere --newer 10
    assert_output ''
}

@test "foo is newer than 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --newer 10
}

@test "fox is not newer than 10 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --newer 10
}

@test "bar is not newer than 10 seconds, but newer than 60 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query bar --newer 10
    executionMarker --timestamp "$NOW" --group samples --query bar --newer 60
}

@test "context of foo that is newer than 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --newer 10 --get-context
    assert_output 'More foo for me.'
}

@test "context of fox that is not newer than 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --newer 10 --get-context
    assert_output 'Two minutes earlier than foo.'
}

@test "timestamp of foo that is newer than 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --newer 10 --get-timestamp
    assert_output '1557046728'
}

@test "timestamp of fox that is not newer than 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --newer 10 --get-timestamp
    assert_output '1557046597'
}

@test "fallback subject is used when subject does not exist" {
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --newer 60
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --newer 10
    run -0 executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --newer 60 --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "fallback subject is ignored when subject is not newer than 10 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --newer 10
}
