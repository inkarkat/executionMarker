#!/usr/bin/env bats

load canned_config
readonly ZERO_TIMESTAMP=$((NOW - 133))

@test "%R-formatted zero diff of fox subject is printed" {
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%R'
    assert_output 'no time'
}

@test "%p-formatted zero diff of fox subject is printed" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%p'
    assert_output 'no time'
}

@test "%p-fallback-formatted zero diff of fox subject is printed" {
    RELDATE=doesNotExist run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%p'
    assert_output 'just now'
}

@test "%s-formatted zero diff of fox subject is printed" {
    run -0 executionMarker --timestamp "$ZERO_TIMESTAMP" --group samples --diff fox --format '%s'
    assert_output 'just now'
}
