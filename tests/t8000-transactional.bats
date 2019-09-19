#!/usr/bin/env bats

load temp_config

clear_lock()
{
    rm -f "${XDG_CONFIG_HOME}/.${1:?}.lock"
}

setup()
{
    clear_lock "$BATS_TEST_NAME"
    initialize_config "$BATS_TEST_NAME" from samples
}



@test "transactional update of a group with a new subject adds a row" {
    executionMarker --transactional --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux"
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	"
}

@test "query and update a subject within an upgraded write transaction, then abort it" {
    executionMarker --start-read-transaction T --group "$BATS_TEST_NAME"
    run executionMarker --within-transaction T --group "$BATS_TEST_NAME" --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'More foo for me.' ]

    executionMarker --upgrade-to-write-transaction T --group "$BATS_TEST_NAME"
    executionMarker --within-transaction T --timestamp "$NOW" --group "$BATS_TEST_NAME" --update foo --context "Transactionally updated"
    assert_config_row "$BATS_TEST_NAME" 2 "foo	$NOW	Transactionally updated"

    run executionMarker --within-transaction T --timestamp "$NOW" --group "$BATS_TEST_NAME" --query foo --get-context
    [ $status -eq 0 ]
    [ "$output" = 'Transactionally updated' ]

    executionMarker --abort-write-transaction T --group "$BATS_TEST_NAME"
    assert_config_row "$BATS_TEST_NAME" 2 "foo	1557046728	More foo for me."
}
