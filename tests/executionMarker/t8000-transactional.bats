#!/usr/bin/env bats

load temp_config

clear_lock()
{
    rm -f "${XDG_DATA_HOME}/.${1:?}.lock"
}

setup()
{
    clear_lock "$BATS_TEST_NAME"
    initialize_config "$BATS_TEST_NAME" from samples
}



@test "transactional update of a new subject adds a row" {
    executionMarker --transactional --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "quux"
    assert_config_row "$BATS_TEST_NAME" \$ "quux	$NOW	"
}

@test "query and update a subject within an upgraded write transaction, then abort it" {
    executionMarker --start-read-transaction T --group "$BATS_TEST_NAME"
    run -0 executionMarker --within-transaction T --group "$BATS_TEST_NAME" --query foo --get-context
    assert_output 'More foo for me.'

    executionMarker --upgrade-to-write-transaction T --group "$BATS_TEST_NAME"
    executionMarker --within-transaction T --timestamp "$NOW" --group "$BATS_TEST_NAME" --update foo --context "Transactionally updated"
    assert_config_row "$BATS_TEST_NAME" 2 "foo	$NOW	Transactionally updated"

    run -0 executionMarker --within-transaction T --timestamp "$NOW" --group "$BATS_TEST_NAME" --query foo --get-context
    assert_output 'Transactionally updated'

    executionMarker --abort-write-transaction T --group "$BATS_TEST_NAME"
    assert_config_row "$BATS_TEST_NAME" 2 "foo	1557046728	More foo for me."
}

@test "transactional fallback subject is used when subject is not within 10 seconds and it is within" {
    run -0 executionMarker --transactional --timestamp "$NOW" --group "$BATS_TEST_NAME" --query fox --fallback-subject foo --fallback-on-time --within 10 --get-context
    assert_output 'More foo for me.'
}
