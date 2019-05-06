#!/usr/bin/env bats

load temp_config

@test "query of multiline context returns all lines" {
    initialize_config "$BATS_TEST_NAME" from samples
    context='Here is
multi-line

text	with
multiple columns'
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "key" --context "$context"

    run executionMarker --group "$BATS_TEST_NAME" --query key --get-context
    [ $status -eq 0 ]
    [ "$output" = "$context" ]
}
