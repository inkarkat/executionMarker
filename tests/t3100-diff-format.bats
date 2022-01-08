#!/usr/bin/env bats

load canned_config

@test "%S-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%S'
    [ $status -eq 0 ]
    [ "$output" = '133' ]
}

@test "[diff is %S]-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '[diff is %S]'
    [ $status -eq 0 ]
    [ "$output" = '[diff is 133]' ]
}

@test "%s-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%s'
    [ $status -eq 0 ]
    [ "$output" = '133 seconds ago' ]
}

@test "%R-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%R'
    [ $status -eq 0 ]
    [ "$output" = '2 minutes ago' ]
}

@test "%2R-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format 'it happened %2R'
    [ $status -eq 0 ]
    [ "$output" = 'it happened 2 minutes and 13 seconds ago' ]
}

@test "%r-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%r'
    [ $status -eq 0 ]
    [ "$output" = '2m ago' ]
}

@test "%2r-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format 'it happened %2r'
    [ $status -eq 0 ]
    [ "$output" = 'it happened 2m and 13s ago' ]
}

@test "format handles %% escaping in diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%%%s%%'
    [ $status -eq 0 ]
    [ "$output" = '%133 seconds ago%' ]
}

@test "repetition of %s-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%s, %s'
    [ $status -eq 0 ]
    [ "$output" = '133 seconds ago, 133 seconds ago' ]
}

@test "combination of formats diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%1r(%R) a.k.a. (%s) %Ss'
    [ $status -eq 0 ]
    [ "$output" = '2m ago(2 minutes ago) a.k.a. (133 seconds ago) 133s' ]
}
