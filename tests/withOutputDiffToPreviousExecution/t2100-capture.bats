#!/usr/bin/env bats

load canned_config

@test "previouslySucceedingFunction only capture stdout" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run withOutputDiffToPreviousExecution -u --stdout --group samples -- previouslySucceedingFunction
    [ $status -eq 1 ]
    [ "$output" = "new problem
--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 0
+exit status: 42
 
-very good" ]
}

@test "previouslyFailingFunction only capture stderr" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run withOutputDiffToPreviousExecution --stderr -u --group samples -- previouslyFailingFunction
    [ $status -eq 1 ]
    [ "$output" = "flaky
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 11
+exit status: 0
 
-flaky" ]
}
