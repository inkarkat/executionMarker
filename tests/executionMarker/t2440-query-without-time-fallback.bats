#!/usr/bin/env bats

load canned_config

@test "fallback subject is used when subject does not exist" {
    ! executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --without 60
    executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --without 10
    run executionMarker --timestamp "$NOW" --group samples --query notInHere --fallback-subject bar --fallback-on-time --without 60 --get-context
    [ $status -eq 1 ]
    [ "$output" = 'Less than a minute earlier than foo.' ]
}

@test "fallback subject is ignored when subject is not without 1000 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject \* --fallback-on-time --without 1000
    run executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject \* --fallback-on-time --without 60 --get-context
    [ $status -eq 0 ]
    [ "$output" = 'Two minutes earlier than foo.' ]
}

@test "fallback subject is used when subject is within 1000 seconds and it is not within" {
    executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject \* --fallback-on-time --without 1000
    run executionMarker --timestamp "$NOW" --group samples --query fox --fallback-subject \* --fallback-on-time --without 1000 --get-context
    [ $status -eq 0 ]
    [ "$output" = 'Yesterday.' ]
}

@test "original subject context is printed when both subject and fallback subjects are within 1000 seconds" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --fallback-subject bar --fallback-on-time --without 1000 --get-context
    [ $status -eq 1 ]
    [ "$output" = 'More foo for me.' ]
}

@test "original subject context is printed when subject is not within but no fallback subject exists" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo --fallback-subject notInHere --fallback-on-time --without 1000
    run executionMarker --timestamp "$NOW" --group samples --query foo --fallback-subject notInHere --fallback-on-time --without 1000 --get-context
    [ $status -eq 1 ]
    [ "$output" = 'More foo for me.' ]
}
