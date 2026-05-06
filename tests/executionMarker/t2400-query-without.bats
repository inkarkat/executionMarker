#!/usr/bin/env bats

load canned_config

@test "non-existing group query for --older fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group doesNotExist --query notInHere --older 10
    assert_output ''
}

@test "non-existing subject query for --older fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group samples --query notInHere --older 10
    assert_output ''
}

@test "foo is not older than 10 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query foo --older 10
}

@test "fox is older than 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query fox --older 10
}

@test "bar is older than 10 seconds, but not older than 60 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query bar --older 10
    ! executionMarker --timestamp "$NOW" --group samples --query bar --older 60
}

@test "context of foo that is not older than 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query foo --older 10 --get-context
    assert_output 'More foo for me.'
}

@test "context of fox that is older than 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query fox --older 10 --get-context
    assert_output 'Two minutes earlier than foo.'
}

@test "timestamp of foo that is not older than 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query foo --older 10 --get-timestamp
    assert_output '1557046728'
}

@test "timestamp of fox that is older than 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query fox --older 10 --get-timestamp
    assert_output '1557046597'
}

@test "fallback subject is used when subject does not exist" {
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --older 60
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --older 10
    run -1 executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --older 60 --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "fallback subject is ignored when subject is not older than 1000 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --older 1000
}
