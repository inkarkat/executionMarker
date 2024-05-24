#!/usr/bin/env bats

load temp_config

@test "subject query within the same minute" {
    readonly MID_MINUTE=1557046770
    executionMarker --timestamp $MID_MINUTE --group "$BATS_TEST_NAME" --update subject

    executionMarker --timestamp $(($MID_MINUTE + 29)) --group "$BATS_TEST_NAME" --query subject --within 'minute'
    ! executionMarker --timestamp $(($MID_MINUTE + 30)) --group "$BATS_TEST_NAME" --query subject --within 'minute'
    executionMarker --timestamp $(($MID_MINUTE - 30)) --group "$BATS_TEST_NAME" --query subject --within 'minute'
    ! executionMarker --timestamp $(($MID_MINUTE - 31)) --group "$BATS_TEST_NAME" --query subject --within 'minute'
}

@test "subject query without the same minute" {
    readonly MID_MINUTE=1557046770
    executionMarker --timestamp $MID_MINUTE --group "$BATS_TEST_NAME" --update subject

    ! executionMarker --timestamp $(($MID_MINUTE + 29)) --group "$BATS_TEST_NAME" --query subject --without 'minute'
    executionMarker --timestamp $(($MID_MINUTE + 30)) --group "$BATS_TEST_NAME" --query subject --without 'minute'
    ! executionMarker --timestamp $(($MID_MINUTE - 30)) --group "$BATS_TEST_NAME" --query subject --without 'minute'
    executionMarker --timestamp $(($MID_MINUTE - 31)) --group "$BATS_TEST_NAME" --query subject --without 'minute'
}
