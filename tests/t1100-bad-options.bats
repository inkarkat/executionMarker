#!/usr/bin/env bats

load canned_config

@test "multiple actions print usage error" {
    run executionMarker --group some-group --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Only one of --update, --diff --query allowed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
