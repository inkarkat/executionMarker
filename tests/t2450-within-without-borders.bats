#!/usr/bin/env bats

load canned_config

@test "foo is within 2 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --within 2s
}

@test "foo is not within 1 second" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo --within 1s
}

@test "foo is without 1 second" {
    executionMarker --timestamp "$NOW" --group samples --query foo --without 1s
}

@test "foo is without 2 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query foo --without 2s
}

@test "foo is not without 3 seconds" {
    ! executionMarker --timestamp "$NOW" --group samples --query foo --without 3s
}
