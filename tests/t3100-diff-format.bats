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

@test "%P-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%P'
    [ $status -eq 0 ]
    [ "$output" = '2 minutes' ]
}

@test "%2P-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format 'it took %2P'
    [ $status -eq 0 ]
    [ "$output" = 'it took 2 minutes and 13 seconds' ]
}

@test "%p-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format '%p'
    [ $status -eq 0 ]
    [ "$output" = '2m' ]
}

@test "%2p-formatted diff of fox subject is printed" {
    run executionMarker --timestamp "$NOW" --group samples --diff fox --format 'it took %2p'
    [ $status -eq 0 ]
    [ "$output" = 'it took 2m and 13s' ]
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

@test "%R-formatted negative diff of fox subject is printed" {
    run executionMarker --timestamp "$((NOW - 140))" --group samples --diff fox --format '%R'
    [ $status -eq 0 ]
    [ "$output" = 'in 7 seconds' ]
}

@test "%p-formatted negative diff of fox subject is printed" {
    run executionMarker --timestamp "$((NOW - 140))" --group samples --diff fox --format '%p'
    [ $status -eq 0 ]
    [ "$output" = '7s' ]
}

@test "%s-formatted negative diff of fox subject is printed" {
    run executionMarker --timestamp "$((NOW - 140))" --group samples --diff fox --format '%s'
    [ $status -eq 0 ]
    [ "$output" = 'in 7 seconds' ]
}
