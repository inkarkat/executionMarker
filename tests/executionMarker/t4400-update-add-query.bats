#!/usr/bin/env bats

load temp_config

@test "update of a new subject and context adds a row and returns an empty previous context" {
    initialize_config "$BATS_TEST_NAME" from samples
    readonly CONTEXT='More inforation for this'

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --context "$CONTEXT" --get-context
    assert_output ''
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "quux" --get-context)" = "$CONTEXT" ]
}

@test "update of a new subject and context adds a row and returns an empty previous timestamp" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --context 'More inforation for this' --get-timestamp
    assert_output ''
}

@test "update of a new subject and context adds a row and returns an empty previous context and timestamp" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --context 'More inforation for this' --get-timestamp --get-context
    assert_output ''
}
