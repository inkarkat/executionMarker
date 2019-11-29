#!/usr/bin/env bats

@test "choose base type data uses XDG_DATA_HOME" {
    export XDG_DATA_HOME="${BATS_TEST_DIRNAME}/config"
    run executionMarker --base-type data --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}

@test "choose base type data uses XDG_RUNTIME_DIR" {
    export XDG_RUNTIME_DIR="${BATS_TEST_DIRNAME}/config"
    run executionMarker --base-type runtime --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}

@test "choose base type cache uses XDG_CACHE_HOME" {
    export XDG_CACHE_HOME="${BATS_TEST_DIRNAME}/config"
    run executionMarker --base-type cache --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}
