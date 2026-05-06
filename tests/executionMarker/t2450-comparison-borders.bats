#!/usr/bin/env bats

load canned_config

@test "foo happened in the past 2 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo -ge -2s
    executionMarker --timestamp "$NOW" --group samples --query foo -eq -2s
    ! executionMarker --timestamp "$NOW" --group samples --query foo -ne -2s
    executionMarker --timestamp "$NOW" --group samples --query foo -le -2s
}

@test "foo did not happen in the past 1 second" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo -ge -1s
    ! executionMarker --timestamp "$NOW" --group samples --query foo -eq -1s
    executionMarker --timestamp "$NOW" --group samples --query foo -ne -1s
    executionMarker --timestamp "$NOW" --group samples --query foo -le -1s
}

@test "foo happened in the past 3 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo -le -3s
    ! executionMarker --timestamp "$NOW" --group samples --query foo -eq -3s
    executionMarker --timestamp "$NOW" --group samples --query foo -ne -3s
    executionMarker --timestamp "$NOW" --group samples --query foo -ge -3s
}
