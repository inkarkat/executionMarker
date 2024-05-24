#!/usr/bin/env bats

load canned_config

@test "previouslySucceedingFunction only capture stdout" {
    run withOutputDiffToPreviousExecution -u --stdout --group samples -- previouslySucceedingFunction
    [ $status -eq 1 ]
    [ "$output" = "new problem
--- previouslySucceedingFunction Fri 24. May 2024 02:38:31 CEST (6 hours ago)
+++ previouslySucceedingFunction Fri 24. May 2024 08:52:30 CEST
@@ -1,3 +1,2 @@
-exit status: 0
+exit status: 42
 
-very good" ]
}

@test "previouslyFailingFunction only capture stderr" {
    run withOutputDiffToPreviousExecution --stderr -u --group samples -- previouslyFailingFunction
    [ $status -eq 1 ]
    [ "$output" = "flaky
--- previouslyFailingFunction Fri 24. May 2024 08:48:53 CEST (4 minutes ago)
+++ previouslyFailingFunction Fri 24. May 2024 08:52:30 CEST
@@ -1,3 +1,2 @@
-exit status: 11
+exit status: 0
 
-flaky" ]
}
