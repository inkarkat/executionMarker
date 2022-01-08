#!/usr/bin/env bats

load temp_config
readonly CONTEXT="Cunningly updated"

@test "update of an existing key overwrites that row with updated timestamp and context and returns the previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-context

    [ $status -eq 0 ]
    [ "$output" = "Two minutes earlier than foo." ]
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox" --get-context)" = "$CONTEXT" ]
}

@test "update of an existing key clears a previous context and returns the previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --get-context

    [ $status -eq 0 ]
    [ "$output" = "Two minutes earlier than foo." ]
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox" --get-context)" = "" ]
}

@test "update of an existing key and --keep-context keeps a previous context and returns the previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --keep-context --get-context

    [ $status -eq 0 ]
    [ "$output" = "Two minutes earlier than foo." ]
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox" --get-context)" = "Two minutes earlier than foo." ]
}

@test "update of an existing key overwrites that row with updated timestamp and context and returns the previous timestamp" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-timestamp

    [ $status -eq 0 ]
    [ "$output" = "1557046597" ]
}

@test "update of an existing key overwrites that row with updated timestamp and context and returns the previous context and timestamp" {
    initialize_config "$BATS_TEST_NAME" from samples

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --get-context --get-timestamp

    [ $status -eq 0 ]
    [ "$output" = "Two minutes earlier than foo.
1557046597" ]
}
