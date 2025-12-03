#!/usr/bin/env bats

load canned_config

@test "no arguments prints message and usage instructions" {
    run -2 executionMarker
    assert_line -n 0 'ERROR: No action passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
  run -2 executionMarker --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
  run -0 executionMarker -h
    refute_line -n 0 -e '^Usage:'
}

@test "additional arguments print short help" {
  run -2 executionMarker --group some-group --query some-subject whatIsMore
    assert_line -n 0 -e '^Usage:'
}
@test "no action prints message and usage instructions" {
    run -2 executionMarker --group some-group
    assert_line -n 0 'ERROR: No action passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "query action with no group prints message and usage instructions" {
    run -2 executionMarker --query foo
    assert_line -n 0 'ERROR: No group passed.'
    assert_line -n 2 -e '^Usage:'
}
