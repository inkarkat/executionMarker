#!/usr/bin/env bats

load temp_config
readonly CONTEXT="Cunningly updated"

@test "update of foo which is within 10 seconds" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "foo" --context "$CONTEXT" --within 10
    assert_output ''
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "foo" --get-context)" = "$CONTEXT" ]
}

@test "update of fox which is not within 10 seconds" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -1 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --within 10s
    assert_output ''
    [ "$(executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --query "fox" --get-context)" = "$CONTEXT" ]
}

@test "update of foo which is not without 10 seconds" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -1 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "foo" --context "$CONTEXT" --without 10
    assert_output ''
}

@test "update of fox which is without 10 seconds" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --without 10s
    assert_output ''
}

@test "update of foo which is within minute returns the previous context" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -0 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "foo" --context "$CONTEXT" --within minute --get-context
    assert_output 'More foo for me.'
}

@test "update of fox which is not within every 90 seconds returns the previous timestamp" {
    initialize_config "$BATS_TEST_NAME" from samples

    run -1 executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "fox" --context "$CONTEXT" --within 'every 90 seconds' --get-timestamp
    assert_output '1557046597'
}

