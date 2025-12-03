#!/usr/bin/env bats

load fixture

@test "custom base dir can be passed" {
    run -0 executionMarker --basedir "${BATS_TEST_DIRNAME}/config" --group samples --query foo --get-context
    assert_output 'More foo for me.'
}
