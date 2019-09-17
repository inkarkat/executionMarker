#!/usr/bin/env bats

load canned_config

@test "multiple actions print usage error" {
    run executionMarker --group some-group --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Only one of --update, --diff, --time, --query, --delete, --start-read-transaction, --start-write-transaction, --upgrade-to-write-transaction, --within-transaction, --end-transaction, --abort-write-transaction allowed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
