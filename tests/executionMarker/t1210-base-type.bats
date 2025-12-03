#!/usr/bin/env bats

load fixture

@test "default base type uses XDG_DATA_HOME" {
    export XDG_DATA_HOME="${BATS_TEST_DIRNAME}/config"
    run -0 executionMarker --group samples --query foo --get-context
    assert_output 'More foo for me.'
}

@test "choose base type config uses XDG_CONFIG_HOME" {
    export XDG_CONFIG_HOME="${BATS_TEST_DIRNAME}/config"
    run -0 executionMarker --base-type config --group samples --query foo --get-context
    assert_output 'More foo for me.'
}

@test "choose base type runtime uses XDG_RUNTIME_DIR" {
    export XDG_RUNTIME_DIR="${BATS_TEST_DIRNAME}/config"
    run -0 executionMarker --base-type runtime --group samples --query foo --get-context
    assert_output 'More foo for me.'
}

@test "choose base type cache uses XDG_CACHE_HOME" {
    export XDG_CACHE_HOME="${BATS_TEST_DIRNAME}/config"
    run -0 executionMarker --base-type cache --group samples --query foo --get-context
    assert_output 'More foo for me.'
}
