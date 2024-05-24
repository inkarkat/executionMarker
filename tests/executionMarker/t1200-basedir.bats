#!/usr/bin/env bats

@test "custom base dir can be passed" {
    run executionMarker --basedir "${BATS_TEST_DIRNAME}/config" --group samples --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]
}
