#!/usr/bin/env bats

load canned_config

@test "fox is older than 10 seconds" {
    executionMarker --timestamp "$NOW" --group samples --query fox --older 10s
}

@test "* is older than 3 minutes" {
    executionMarker --timestamp "$NOW" --group samples --query \* --older 3m
}

@test "foo is not older than 12 hours" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query foo --older 12h
}

