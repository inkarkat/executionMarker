#!/usr/bin/env bats

load canned_config
export TZ=Etc/UTC

@test "formatted time of foo subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --time foo --format '%F %T'
    assert_output '2019-05-05 08:58:48'
}

@test "formatted time of fallback fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --time notInHere --fallback-subject fox --format '%F_%T'
    assert_output '2019-05-05_08:56:37'
}

@test "time of foo subject in default format is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --time foo --format ''
    refute_output '1557046728'
}
