#!/usr/bin/env bats

load canned_config

assert_one_action_message()
{
    [ "${lines[0]}" = 'ERROR: Only one of --update, --diff, --time, --query, --delete, --start-read-transaction, --start-write-transaction, --upgrade-to-write-transaction, --within-transaction, --end-transaction, --abort-write-transaction allowed.' ]
}
assert_tx_error_message()
{
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with --no-transaction or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
}

@test "multiple actions print usage error" {
    run executionMarker --group some-group --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    assert_one_action_message
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "conflicting (non-)transaction actions print usage error" {
    run executionMarker --start-read-transaction T --group some-group --query foo
    [ $status -eq 2 ]
    assert_one_action_message
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "conflicting transaction actions print usage error" {
    run executionMarker --transactional --start-read-transaction T --group some-group --query foo
    [ $status -eq 2 ]
    assert_tx_error_message
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "start and within actions from the transaction set print usage error" {
    run executionMarker --start-read-transaction T --within-transaction T --group some-group
    [ $status -eq 2 ]
    assert_tx_error_message
    [ "${lines[2]%% *}" = 'Usage:' ]
}
