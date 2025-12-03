#!/usr/bin/env bats

load canned_config

@test "previouslySucceedingFunction only capture stdout" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -1 withOutputDiffToPreviousExecution -u --stdout --group samples -- previouslySucceedingFunction
    assert_output - <<'EOF'
new problem
--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (22439 seconds ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 0
+exit status: 42
 
-very good
EOF
}

@test "previouslyFailingFunction only capture stderr" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -1 withOutputDiffToPreviousExecution --stderr -u --group samples -- previouslyFailingFunction
    assert_output - <<'EOF'
flaky
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217 seconds ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 11
+exit status: 0
 
-flaky
EOF
}

@test "commands with both stdout and stderr" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -99 withOutputDiffToPreviousExecution -u --group samples -c 'echo message' -c 'echo error >&2' -c 'echo from stdout' -c 'echo from stderr >&2'
    assert_output - <<'EOF'
--- (no previous execution)
+++ echo Fri May 24 06:52:30 UTC 2024
@@ -0,0 +1,6 @@
+exit status: 0
+
+message
+error
+from stdout
+from stderr
EOF
}
