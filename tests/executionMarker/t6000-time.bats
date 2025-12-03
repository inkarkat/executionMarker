#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run -4 executionMarker --timestamp "$NOW" --group samples --time notInHere
    assert_output ''
}

@test "time of foo subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --time foo
    assert_output '1557046728'
}

@test "time of fallback fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --time notInHere --fallback-subject fox
    assert_output '1557046597'
}
