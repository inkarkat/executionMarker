#!/usr/bin/env bats

load canned_config

@test "no arguments prints message and usage instructions" {
    run executionMarker
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No action passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run executionMarker --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run executionMarker -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "additional arguments print short help" {
  run executionMarker --group some-group --query some-subject whatIsMore
    [ $status -eq 2 ]
    [ "${lines[0]%% *}" = 'Usage:' ]
}
@test "no action prints message and usage instructions" {
    run executionMarker --group some-group
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No action passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "query action with no group prints message and usage instructions" {
    run executionMarker --query foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No group passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
