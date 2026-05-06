#!/usr/bin/env bats

load canned_config
readonly NEGATIVE_TIMESTAMP=$((NOW - 140))

@test "negative diff in long-unit precise format (formerly %R) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --output precise --long-units
    assert_output 'in 7 seconds'
}

@test "negative diff in non-directional precise format (formerly %p) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --output precise --no-direction
    assert_output '-7s'
}

@test "negative diff in long-unit precise format (formerly %s) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NEGATIVE_TIMESTAMP" --group samples --diff fox --output precise --long-units
    assert_output 'in 7 seconds'
}
