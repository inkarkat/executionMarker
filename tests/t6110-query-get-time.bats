#!/usr/bin/env bats

load canned_config

@test "query prints formatted time of foo subject" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --get-time '%F %T'
    [ $status -eq 0 ]
    [ "$output" = '2019-05-05 10:58:48' ]
}

@test "query prints formatted time of foo subject together with context and timestamp" {
    run executionMarker --timestamp "$NOW" --group samples --query foo --get-context --get-time '%F %T' --get-timestamp
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.
2019-05-05 10:58:48
1557046728' ]
}

@test "query prints formatted time of fox subject together with --within 10" {
    run executionMarker --timestamp "$NOW" --group samples --query fox --within 10 --get-time 'time is %T'
    [ $status -eq 1 ]
    [ "$output" = 'time is 10:56:37' ]
}

