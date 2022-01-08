#!/usr/bin/env bats

load temp_config

@test "update and context increment of a new subject initializes the context to 1" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux" --increment-context
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	1"
}

@test "update and context increment of an existing key and non-number context overwrites that row with updated timestamp and keeps the context" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --increment-context

    assert_config_row "$BATS_TEST_NAME" 3 "fox	$NOW	Two minutes earlier than foo."
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}

@test "update and context increment of an existing key overwrites that row with updated timestamp and incremented context" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context 41
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --increment-context

    assert_config_row "$BATS_TEST_NAME" 3 "fox	$NOW	42"
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}
