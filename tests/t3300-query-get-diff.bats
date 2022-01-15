#!/usr/bin/env bats

load canned_config

@test "query prints formatted time difference of foo subject" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --get-diff '%R'
    [ $status -eq 0 ]
    [ "$output" = '2 seconds ago' ]
}

@test "query prints formatted time difference of foo subject together with context and timestamp" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --get-context --get-diff 'last was %s' --get-timestamp
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.
last was 2 seconds ago
1557046728' ]
}

@test "query prints formatted time difference of fox subject together with formatted time and --within 10" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --get-time '%F' --within 10 --get-diff '%2r'
    [ $status -eq 1 ]
    [ "$output" = '2019-05-05
2m and 13s ago' ]
}
