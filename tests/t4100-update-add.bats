#!/usr/bin/env bats

load temp_config

@test "update of a group with a new subject adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux"
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	"
}

@test "update of a group with a new subject and context adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples
    readonly CONTEXT='More inforation for this'

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --context "$CONTEXT"
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	$CONTEXT"
}

@test "update of a group with a new subject and --keep-context adds a row with empty context" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --keep-context
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	"
}
