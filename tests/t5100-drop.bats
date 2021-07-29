#!/usr/bin/env bats

load temp_config

@test "drop of an existing table removes the file" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --drop

    [ ! -e "${XDG_DATA_HOME}/${BATS_TEST_NAME}" ]
    ! executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox"
}

@test "drop of non-existing table fails with 1" {
    initialize_config "$BATS_TEST_NAME" from samples
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --drop

    run executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --drop
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
