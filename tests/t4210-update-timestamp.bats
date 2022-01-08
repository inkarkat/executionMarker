#!/usr/bin/env bats

load temp_config

@test "update of an existing key and passed timestamp overwrites that row with the timestamp and context, both can be re-read" {
    initialize_config "$BATS_TEST_NAME" from samples
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    readonly TIMESTAMP=111222333
    readonly SUBJECT=fox
    readonly CONTEXT="Cunningly updated"
    executionMarker --timestamp "$TIMESTAMP" --group "$BATS_TEST_NAME" --update "$SUBJECT" --context "$CONTEXT"

    assert_config_row "$BATS_TEST_NAME" 3 "$SUBJECT	$TIMESTAMP	$CONTEXT"

    run executionMarker --group "$BATS_TEST_NAME" --query "$SUBJECT" --get-context
    [ $status -eq 0 ]
    [ "$output" = "$CONTEXT" ]

    run executionMarker --group "$BATS_TEST_NAME" --query "$SUBJECT" --get-timestamp
    [ $status -eq 0 ]
    [ "$output" = "$TIMESTAMP" ]
}
