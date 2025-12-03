#!/usr/bin/env bats

load temp_config

@test "delete of an existing subject removes the record" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --delete "fox"

    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq $((rowNum - 1)) ]
    ! executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox"
}

@test "delete of non-existing subject fails with 1" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run -4 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --delete notInHere
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}
