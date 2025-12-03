#!/usr/bin/env bats

load canned_config

@test "previouslySucceedingFunction run with --or-output still indicates changed exit status and output" {
    run -1 withOutputDiffToPreviousExecution --or-output -u --group samples -- previouslySucceedingFunction
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

@test "testFunction run with --or-output shows the output" {
    run -0 withOutputDiffToPreviousExecution --or-output -u --group samples -- testFunction
    assert_output 'just a test'
}

@test "newFunction run with --or-output still indicates new via exit status 99 and diff" {
    run -99 withOutputDiffToPreviousExecution --or-output -u --group samples -- newFunction arg1 arg2 ...
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

@test "previouslySucceedingFunction run with --and-output prints output and indicates changed exit status and output" {
    run -1 withOutputDiffToPreviousExecution --and-output -u --group samples -- previouslySucceedingFunction
    assert_output - <<'EOF'
new problem

--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 0
+exit status: 42
 
-very good
+new problem
EOF
}

@test "testFunction run with --and-output shows the output" {
    run -0 withOutputDiffToPreviousExecution --and-output -u --group samples -- testFunction
    assert_output 'just a test'
}

@test "newFunction run with --and-output prints output and indicates new via exit status 99 and diff" {
    run -99 withOutputDiffToPreviousExecution --and-output -u --group samples -- newFunction arg1 arg2 ...
    assert_output - <<'EOF'
this is all
brand new

--- (no previous execution)
+++ newFunction Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,4 @@
+exit status: 0
+
+this is all
+brand new
EOF
}
