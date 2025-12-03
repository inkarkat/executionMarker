#!/usr/bin/env bats

load canned_config

setup()
{
    cp --force --recursive "${BATS_TEST_DIRNAME}/config/samples" "${XDG_DATA_HOME}/transactional"
}

@test "transactional previouslyFailingFunction run indicates changed exit status" {
    run -1 withOutputDiffToPreviousExecution --transactional -u --group transactional -- previouslyFailingFunction
    assert_output - <<'EOF'
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky
EOF
}

@test "explicitly managed transaction" {
    executionMarker --start-write-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST --group transactional
	run withOutputDiffToPreviousExecution --within-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST -u --group transactional -- previouslyFailingFunction
    executionMarker --end-transaction WITHOUTPUTDIFFTOPREVIOUSEXECUTION_TEST --group transactional

    assert_failure 1
    assert_output - <<'EOF'
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky
EOF
}
