#!/usr/bin/env bats

load canned_config

@test "previouslySucceedingFunction run with --or-output still indicates changed exit status and output" {
    run withOutputDiffToPreviousExecution --or-output -u --group samples -- previouslySucceedingFunction
    [ $status -eq 1 ]
    [ "$output" = "--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 0
+exit status: 42
 
-very good
+new problem" ]
}

@test "testFunction run with --or-output shows the output" {
    run withOutputDiffToPreviousExecution --or-output -u --group samples -- testFunction
    [ $status -eq 0 ]
    [ "$output" = "just a test" ]
}

@test "newFunction run with --or-output still indicates new via exit status 99 and diff" {
    run withOutputDiffToPreviousExecution --or-output -u --group samples -- newFunction arg1 arg2 ...
    [ $status -eq 99 ]
    [ "$output" = "--- (no previous execution)
+++ newFunction Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new" ]
}

@test "previouslySucceedingFunction run with --and-output prints output and indicates changed exit status and output" {
    run withOutputDiffToPreviousExecution --and-output -u --group samples -- previouslySucceedingFunction
    [ $status -eq 1 ]
    [ "$output" = "new problem

--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 0
+exit status: 42
 
-very good
+new problem" ]
}

@test "testFunction run with --and-output shows the output" {
    run withOutputDiffToPreviousExecution --and-output -u --group samples -- testFunction
    [ $status -eq 0 ]
    [ "$output" = "just a test" ]
}

@test "newFunction run with --and-output prints output and indicates new via exit status 99 and diff" {
    run withOutputDiffToPreviousExecution --and-output -u --group samples -- newFunction arg1 arg2 ...
    [ $status -eq 99 ]
    [ "$output" = "this is all
brand new

--- (no previous execution)
+++ newFunction Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new" ]
}
