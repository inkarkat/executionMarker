#!/usr/bin/env bats

load canned_config

setup()
{
    cannedConfigSetup
    skipIfMissingPreciseDiffOutputDependencies
}

@test "previouslySucceedingFunction only capture stdout" {
    run -1 withOutputDiffToPreviousExecution -u --stdout --group samples -- previouslySucceedingFunction
    assert_output - <<'EOF'
new problem
--- previouslySucceedingFunction Fri May 24 00:38:31 UTC 2024 (06:13:59 ago)
+++ previouslySucceedingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 0
+exit status: 42
 
-very good
EOF
}

@test "previouslyFailingFunction only capture stderr" {
    run -1 withOutputDiffToPreviousExecution --stderr -u --group samples -- previouslyFailingFunction
    assert_output - <<'EOF'
flaky
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (3m 37s ago)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,2 @@
-exit status: 11
+exit status: 0
 
-flaky
EOF
}

@test "commands with both stdout and stderr" {
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
