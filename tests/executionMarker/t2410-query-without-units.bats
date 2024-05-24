#!/usr/bin/env bats

load canned_config

@test "fox is without 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query fox --without 10s
}

@test "* is without 3 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query \* --without 3m
}

@test "foo is not without 12 hours" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --without 12h
    [ $status -eq 1 ]
}

