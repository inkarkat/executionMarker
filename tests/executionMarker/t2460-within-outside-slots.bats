#!/usr/bin/env bats

load temp_config

readonly MID_MINUTE=1557046770

@test "subject query within the same minute" {
    executionMarker --timestamp $MID_MINUTE --group "$BATS_TEST_NAME" --update subject

    executionMarker --timestamp $((MID_MINUTE + 29)) --group "$BATS_TEST_NAME" --query subject --within minute
    ! executionMarker --timestamp $((MID_MINUTE + 30)) --group "$BATS_TEST_NAME" --query subject --within minute
    executionMarker --timestamp $((MID_MINUTE - 30)) --group "$BATS_TEST_NAME" --query subject --within minute
    ! executionMarker --timestamp $((MID_MINUTE - 31)) --group "$BATS_TEST_NAME" --query subject --within minute
}

@test "subject query outside the same minute" {
    executionMarker --timestamp $MID_MINUTE --group "$BATS_TEST_NAME" --update subject

    ! executionMarker --timestamp $((MID_MINUTE + 29)) --group "$BATS_TEST_NAME" --query subject --outside minute
    executionMarker --timestamp $((MID_MINUTE + 30)) --group "$BATS_TEST_NAME" --query subject --outside minute
    ! executionMarker --timestamp $((MID_MINUTE - 30)) --group "$BATS_TEST_NAME" --query subject --outside minute
    executionMarker --timestamp $((MID_MINUTE - 31)) --group "$BATS_TEST_NAME" --query subject --outside minute
}
