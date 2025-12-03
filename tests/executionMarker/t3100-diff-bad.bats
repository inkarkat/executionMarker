#!/usr/bin/env bats

load canned_config

@test "diff cannot be combined with context printing" {
    run -2 executionMarker --timestamp "$NOW" --group samples --diff foo --get-context
    assert_line -n 0 "ERROR: Cannot query additional information with --diff; use --query instead."
    assert_line -n 2 -e '^Usage:'
}

@test "diff cannot be combined with timestamp printing" {
    run -2 executionMarker --timestamp "$NOW" --group samples --diff foo --get-timestamp
    assert_line -n 0 "ERROR: Cannot query additional information with --diff; use --query instead."
    assert_line -n 2 -e '^Usage:'
}
