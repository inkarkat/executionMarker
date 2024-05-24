#!/usr/bin/env bats

load canned_config

@test "override ID to compare against previous true run" {
    run withOutputDiffToPreviousExecution --command-id true -u --group samples -- testFunction
    [ $status -eq 1 ]
    [ "$output" = "--- true Tue 25. Oct 2022 04:57:46 CEST (2 years ago)
+++ true Fri 24. May 2024 08:52:30 CEST
@@ -1,2 +1,3 @@
 exit status: 0
 
+just a test" ]
}

@test "newFunction run indicates new via exit status 99 and diff" {
    run withOutputDiffToPreviousExecution --command-id CUSTOM -u --group samples -- newFunction arg1 arg2 ...
    [ $status -eq 99 ]
    [ "$output" = "--- (no previous execution)
+++ CUSTOM Fri 24. May 2024 08:52:30 CEST
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new" ]
}
