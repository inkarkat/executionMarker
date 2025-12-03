#!/usr/bin/env bats

load canned_config

assert_one_action_message()
{
    assert_line -n 0 'ERROR: Only one of --update, --diff, --time, --query, --delete, --drop, --start-read-transaction, --start-write-transaction, --upgrade-to-write-transaction, --within-transaction, --end-transaction, --abort-write-transaction allowed.'
}
assert_tx_error_message()
{
    assert_line -n 0 'ERROR: --transactional cannot be combined with --no-transaction or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.'
}

@test "multiple actions print usage error" {
    run -2 executionMarker --group some-group --query foo --update "fox	blah	blah"
    assert_one_action_message
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting (non-)transaction actions print usage error" {
    run -2 executionMarker --start-read-transaction T --group some-group --query foo
    assert_one_action_message
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting transaction actions print usage error" {
    run -2 executionMarker --transactional --start-read-transaction T --group some-group --query foo
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "start and within actions from the transaction set print usage error" {
    run -2 executionMarker --start-read-transaction T --within-transaction T --group some-group
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting --keep-context and --context print usage error" {
    run -2 executionMarker --group some-group --update 'foo' --keep-context --context 'new context'
    assert_line -n 0 "ERROR: Can only specify one of -C|--keep-context, -c|--context, or --increment-context."
    assert_line -n 2 -e '^Usage:'
}
