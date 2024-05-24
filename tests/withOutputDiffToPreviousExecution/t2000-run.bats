#!/usr/bin/env bats

load canned_config

@test "true run has no differences" {
    run withOutputDiffToPreviousExecution -u --group samples -- true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "false run has no differences" {
    run withOutputDiffToPreviousExecution -u --group samples -- false
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "testFunction run has no differences" {
    run withOutputDiffToPreviousExecution -u --group samples -- testFunction
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "newFunction run indicates new via exit status 99 and diff" {
    run withOutputDiffToPreviousExecution -u --group samples -- newFunction arg1 arg2 ...
    [ $status -eq 99 ]
    [ "$output" = "--- (no previous execution)
+++ newFunction Fri 24. May 2024 08:52:30 CEST
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new" ]
}

@test "second newFunction run has no differences" {
    run withOutputDiffToPreviousExecution -u --group samples -- newFunction
    run withOutputDiffToPreviousExecution -u --group samples -- newFunction
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "previouslyFailingFunction run indicates changed exit status" {
    run withOutputDiffToPreviousExecution -u --group samples -- previouslyFailingFunction
    [ $status -eq 1 ]
    [ "$output" = "--- previouslyFailingFunction Fri 24. May 2024 08:48:53 CEST (4 minutes ago)
+++ previouslyFailingFunction Fri 24. May 2024 08:52:30 CEST
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky" ]
}

@test "previouslySucceedingFunction run indicates changed exit status and output" {
    run withOutputDiffToPreviousExecution -u --group samples -- previouslySucceedingFunction
    [ $status -eq 1 ]
    [ "$output" = "--- previouslySucceedingFunction Fri 24. May 2024 02:38:31 CEST (6 hours ago)
+++ previouslySucceedingFunction Fri 24. May 2024 08:52:30 CEST
@@ -1,3 +1,3 @@
-exit status: 0
+exit status: 42
 
-very good
+new problem" ]
}
