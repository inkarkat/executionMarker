#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run -4 executionMarker --timestamp "$NOW" --group samples --diff notInHere
    assert_output ''
}

@test "diff of foo subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff foo
    assert_output '2'
}

@test "diff of fallback fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff notInHere --fallback-subject fox
    assert_output '133'
}
