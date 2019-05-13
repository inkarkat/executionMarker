#!/usr/bin/env bats

load canned_config

@test "formatted time of foo subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --time foo --format '%F %T'
    [ $status -eq 0 ]
    [ "$output" = '2019-05-05 10:58:48' ]
}

@test "formatted time of fallback fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --time notInHere --fallback-subject fox --format '%F_%T'
    [ $status -eq 0 ]
    [ "$output" = '2019-05-05_10:56:37' ]
}
