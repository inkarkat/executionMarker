#!/usr/bin/env bats

load canned_config

@test "true run has no differences" {
    run -0 withOutputDiffToPreviousExecution -u --group samples -- true
    assert_output ''
}

@test "false run has no differences" {
    run -0 withOutputDiffToPreviousExecution -u --group samples -- false
    assert_output ''
}

@test "testFunction run has no differences" {
    run -0 withOutputDiffToPreviousExecution -u --group samples -- testFunction
    assert_output ''
}

@test "newFunction run indicates new via exit status 99 and diff" {
    run -99 withOutputDiffToPreviousExecution -u --group samples -- newFunction arg1 arg2 ...
    assert_output - <<'EOF'
--- (no previous execution)
+++ newFunction Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new
EOF
}

@test "second newFunction run has no differences" {
    run withOutputDiffToPreviousExecution -u --group samples -- newFunction
    run -0 withOutputDiffToPreviousExecution -u --group samples -- newFunction
    assert_output ''
}

@test "previouslyFailingFunction run indicates changed exit status" {
    run -1 withOutputDiffToPreviousExecution -u --group samples -- previouslyFailingFunction
    assert_output - <<'EOF'
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky
EOF
}

@test "previouslySucceedingFunction run indicates changed exit status and output" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -1 withOutputDiffToPreviousExecution -u --group samples -- previouslySucceedingFunction
    assert_output - <<'EOF'
--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 0
+exit status: 42
 
-very good
+new problem
EOF
}
