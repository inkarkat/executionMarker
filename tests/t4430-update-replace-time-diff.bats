#!/usr/bin/env bats

load temp_config
readonly CONTEXT="Cunningly updated"

@test "update of an existing key overwrites that row and returns the previous formatted time" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-time '%F %T'

    [ $status -eq 0 ]
    [ "$output" = '2019-05-05 10:56:37' ]
}

@test "update of an existing key overwrites that row and returns the previous formatted time difference" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-diff '%s'

    [ $status -eq 0 ]
    [ "$output" = '133 seconds ago' ]
}

@test "update of an existing key overwrites that row and returns the previous formatted time and difference" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-time '%F %T' --get-diff '%s'

    [ $status -eq 0 ]
    [ "$output" = '2019-05-05 10:56:37
133 seconds ago' ]
}
