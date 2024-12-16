#!/usr/bin/env bats

load canned_config

setup()
{
    cp --force --recursive "${BATS_TEST_DIRNAME}/config/samples" "${XDG_DATA_HOME}/transactional"
}

@test "transactional previouslyFailingFunction run indicates changed exit status" {
    run withOutputDiffToPreviousExecution --transactional -u --group transactional -- previouslyFailingFunction
    [ $status -eq 1 ]
    [ "$output" = "--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky" ]
}

@test "explicitly managed transaction" {
    executionMarker --start-write-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST --group transactional
	run withOutputDiffToPreviousExecution --within-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST -u --group transactional -- previouslyFailingFunction
    executionMarker --end-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST --group transactional

    [ $status -eq 1 ]
    [ "$output" = "--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky" ]
}
