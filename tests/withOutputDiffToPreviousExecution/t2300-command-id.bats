#!/usr/bin/env bats

load canned_config

@test "override ID to compare against previous true run" {
    run -1 withOutputDiffToPreviousExecution --command-id true -u --group samples -- testFunction
    assert_output - <<'EOF'
--- true Tue Oct 25 02:57:46 UTC 2022 (49866884 seconds ago)
+++ true Fri May 24 06:52:30 UTC 2024
@@ -1,2 +1,3 @@
 exit status: 0
 
+just a test
EOF
}

@test "newFunction run indicates new via exit status 99 and diff" {
    run -99 withOutputDiffToPreviousExecution --command-id CUSTOM -u --group samples -- newFunction arg1 arg2 ...
    assert_output - <<'EOF'
--- (no previous execution)
+++ CUSTOM Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new
EOF
}
