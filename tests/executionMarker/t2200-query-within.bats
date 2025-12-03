#!/usr/bin/env bats

load canned_config

@test "non-existing group query for within fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group doesNotExist --query notInHere --within 10
    assert_output ''
}

@test "non-existing subject query for within fails with 4" {
    run -4 executionMarker --timestamp "$NOW" --group samples --query notInHere --within 10
    assert_output ''
}

@test "foo is within 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within 10
}

@test "fox is not within 10 seconds" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within 10
}

@test "bar is not within 10 seconds, but within 60 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query bar --within 10
    executionMarker --timestamp "$NOW" --group samples --query bar --within 60
}

@test "context of foo that is within 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --within 10 --get-context
    assert_output 'More foo for me.'
}

@test "context of fox that is not within 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within 10 --get-context
    assert_output 'Two minutes earlier than foo.'
}

@test "timestamp of foo that is within 10 seconds" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --within 10 --get-timestamp
    assert_output '1557046728'
}

@test "timestamp of fox that is not within 10 seconds is printed, too" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within 10 --get-timestamp
    assert_output '1557046597'
}

@test "fallback subject is used when subject does not exist" {
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --within 60
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --within 10
    run -0 executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --within 60 --get-context
    assert_output 'Less than a minute earlier than foo.'
}

@test "fallback subject is ignored when subject is not within 10 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --within 10
}
