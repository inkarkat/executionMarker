#!/usr/bin/env bats

load temp_config

@test "update of a non-existing group initializes it with a default header" {
    clean_config "$BATS_TEST_NAME"

    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "newSubject"

    assert_config_row "$BATS_TEST_NAME" 1 "# SUBJECT	TIMESTAMP	CONTEXT"
    assert_config_row "$BATS_TEST_NAME" \$ "newSubject	$NOW	"
}
