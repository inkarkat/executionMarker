#!/usr/bin/env bats

load temp_config

@test "update of a new subject that contains spaces adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update 'this with spaces'
    assert_config_row "$BATS_TEST_NAME" \$ "this with spaces	$NOW	"
}

@test "timestamp of subject that contains spaces can be queried" {
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update 'this with spaces'
    run -0 executionMarker --group "$BATS_TEST_NAME" --query 'this with spaces' --get-timestamp
    assert_output "$NOW"
}

@test "update of a new subject that contains backslashes adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update '\this/with\backslash'
    assert_config_row "$BATS_TEST_NAME" \$ "\\\\this/with\\\\backslash	$NOW	"
}

@test "timestamp of subject that contains backslashes can be queried" {
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update '\this/with\backslash'
    run -0 executionMarker --group "$BATS_TEST_NAME" --query '\this/with\backslash' --get-timestamp
    assert_output "$NOW"
}

@test "update of a new subject that contains newlines adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update $'this\nhas\nnewlines'
    assert_config_row "$BATS_TEST_NAME" \$ "this\\nhas\\nnewlines	$NOW	"
}

@test "timestamp of subject that contains newlines can be queried" {
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update $'this\nhas\nnewlines'
    run -0 executionMarker --group "$BATS_TEST_NAME" --query $'this\nhas\nnewlines' --get-timestamp
    assert_output "$NOW"
}

@test "update of a new subject that contains tab characters adds a row" {
    initialize_config "$BATS_TEST_NAME" from samples

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update $'this\twith\ttab characters'
    assert_config_row "$BATS_TEST_NAME" \$ "this with tab characters	$NOW	"
}

@test "timestamp of subject that contains tab characters can be queried" {
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update $'this\twith\ttab characters'
    run -0 executionMarker --group "$BATS_TEST_NAME" --query $'this\twith\ttab characters' --get-timestamp
    assert_output "$NOW"
}

@test "timestamp of fallback subject that contains tab characters can be queried" {
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update $'this\twith\ttab characters'
    run -0 executionMarker --group "$BATS_TEST_NAME" --query notInHere --fallback-subject $'this\twith\ttab characters' --get-timestamp
    assert_output "$NOW"
}
