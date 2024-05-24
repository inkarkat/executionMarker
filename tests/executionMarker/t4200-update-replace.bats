#!/usr/bin/env bats

load temp_config

@test "update of an existing key overwrites that row with updated timestamp and context" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "Cunningly updated"

    assert_config_row "$BATS_TEST_NAME" 3 "fox	$NOW	Cunningly updated"
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}

@test "update of an existing key clears a previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox"

    assert_config_row "$BATS_TEST_NAME" 3 "fox	$NOW	"
}

@test "update of an existing key and --keep-context keeps a previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --keep-context

    assert_config_row "$BATS_TEST_NAME" 3 "fox	$NOW	Two minutes earlier than foo."
}
