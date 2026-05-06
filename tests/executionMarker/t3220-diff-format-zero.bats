#!/usr/bin/env bats

load canned_config
readonly ZERO_TIMESTAMP=$((NOW - 133))

@test "zero diff in precise format (formerly %R) of fox subject is printed" {
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --output precise
    assert_output '0s'
}

@test "zero diff in best-unit format (formerly %p) of fox subject is printed" {
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --output best-unit
    assert_output 'just now'
}

@test "zero diff (formerly %s format) of fox subject is printed" {
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox
    assert_output '0'
}
