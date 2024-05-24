#!/usr/bin/env bats

load canned_config

@test "non-existing group query for without fails with 4" {
    run executionMarker --timestamp "$NOW" --group doesNotExist --query notInHere --without 10
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "non-existing subject query for without fails with 4" {
    run executionMarker --timestamp "$NOW" --group samples --query notInHere --without 10
    [ $status -eq 4 ]
    [ -z "$output" ]
}

@test "foo is not without 10 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --without 10
    [ $status -eq 1 ]
}

@test "fox is without 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query fox --without 10
}

@test "bar is without 10 seconds, but not without 60 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query bar --without 10
    ! executionMarker --timestamp "$NOW" --group samples --query bar --without 60
}

@test "context of foo that is not without 10 seconds is printed, too" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --without 10 --get-context
    [ $status -eq 1 ]
    [ "$output" = "More foo for me." ]
}

@test "context of fox that is without 10 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --without 10 --get-context
    [ $status -eq 0 ]
    [ "$output" = "Two minutes earlier than foo." ]
}

@test "timestamp of foo that is not without 10 seconds is printed, too" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --without 10 --get-timestamp
    [ $status -eq 1 ]
    [ "$output" = '1557046728' ]
}

@test "timestamp of fox that is without 10 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --without 10 --get-timestamp
    [ $status -eq 0 ]
    [ "$output" = '1557046597' ]
}

@test "fallback subject is used when subject does not exist" {
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --without 60
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --without 10
    run executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --without 60 --get-context
    [ $status -eq 1 ]
    [ "$output" = 'Less than a minute earlier than foo.' ]
}

@test "fallback subject is ignored when subject is not without 1000 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject foo --without 1000
}
