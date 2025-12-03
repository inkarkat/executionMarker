#!/usr/bin/env bats

load canned_config

@test "time cannot be combined with context printing" {
    run -2 executionMarker --timestamp "$NOW" --group samples --time foo --get-context
    assert_line -n 0 "ERROR: Cannot query additional information with --time; use --query instead."
    assert_line -n 2 -e '^Usage:'
}

@test "time cannot be combined with timestamp printing" {
    run -2 executionMarker --timestamp "$NOW" --group samples --time foo --get-timestamp
    assert_line -n 0 "ERROR: Cannot query additional information with --time; use --query instead."
    assert_line -n 2 -e '^Usage:'
}
