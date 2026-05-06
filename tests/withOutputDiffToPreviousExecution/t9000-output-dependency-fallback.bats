#!/usr/bin/env bats

load canned_config

@test "previouslyFailingFunction run indicates changed exit status with plain date difference on missing dependency" {
    DATEDIFF=doesNotExist run -1 withOutputDiffToPreviousExecution -u --group samples -- previouslyFailingFunction
    assert_output - <<'EOF'
--- previouslyFailingFunction Fri May 24 06:48:53 UTC 2024 (217)
+++ previouslyFailingFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 11
+exit status: 0
 
 flaky
EOF
}
