#!/usr/bin/env bats

load canned_config

@test "diff with output format all (formerly %S) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --output all
    assert_output '133 seconds = 2.2 minutes = 2m 13s ago'
}

@test "diff with prefix and suffix of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --output seconds --no-direction --prefix '[diff is ' --suffix ']'
    assert_output '[diff is 133]'
}

@test "diff in smallest unit (formerly %s) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --output smallest-unit
    assert_output '133 seconds ago'
}

@test "diff in best unit (formerly %R) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --output best-unit
    assert_output '2.2 minutes ago'
}

@test "diff in precise long unit format (formerly %2R) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --prefix 'it happened ' --output precise --long-units
    assert_output 'it happened 2 minutes and 13 seconds ago'
}

@test "diff in precise 1-unit format (formerly %r) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --output precise --precision 1
    assert_output '2m ago'
}

@test "diff in prefixed precise format (formerly %2r) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --prefix 'it happened ' --output precise
    assert_output 'it happened 2m 13s ago'
}

@test "diff in precise long 1-unit format (formerly %P) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --no-direction --output precise --precision 1 --long-units
    assert_output '2 minutes'
}

@test "diff in prefixed precise long-unit format (formerly %2P) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --no-direction --prefix 'it took ' --output precise --long-units
    assert_output 'it took 2 minutes and 13 seconds'
}

@test "diff in 1-unit precise non-directional format (formerly %p) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --no-direction --output precise --precision 1
    assert_output '2m'
}

@test "diff in prefixed precise non-directional format (formerly %2p) of fox subject is printed" {
    run -0 executionMarker --timestamp "$NOW" --group samples --diff fox --no-direction --prefix 'it took ' --output precise
    assert_output 'it took 2m 13s'
}
