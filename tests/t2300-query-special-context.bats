#!/usr/bin/env bats

load temp_config

testWithContext()
{
    context="$1"; shift
    initialize_config "$BATS_TEST_NAME" from samples
    executionMarker --timestamp "$NOW" --group "$BATS_TEST_NAME" --update "key" --context "$context"

    run executionMarker --group "$BATS_TEST_NAME" --query key --get-context
    [ $status -eq 0 ]
    [ "$output" = "$context" ]
}


@test "query of context with spaces" {
    testWithContext 'this has spaces'
}

@test "query of context with backslashes" {
    testWithContext '\this/with\backslash'
}

@test "query of context with tab characters" {
    testWithContext $'this\twith\ttab characters'
}

@test "query of multiline context returns all lines" {
    testWithContext 'Here is
multi-line

text	with
multiple columns'
}

@test "query of context with newlines" {
    testWithContext $'this\nhas\nnewlines'
}
