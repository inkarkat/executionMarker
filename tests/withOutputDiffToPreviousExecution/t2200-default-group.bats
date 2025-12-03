#!/usr/bin/env bats

load canned_config

@test "testFunction run without a group uses interactive runtime group" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    export XDG_RUNTIME_DIR="$BATS_TMPDIR"
    cp --force --recursive "${BATS_TEST_DIRNAME}/config/interactive" "${XDG_RUNTIME_DIR}/"

    run -1 withOutputDiffToPreviousExecution -u -- testFunction
    assert_output - <<'EOF'
--- testFunction Fri May 24 08:40:00 UTC 2024 ( in -6450 seconds)
+++ testFunction Fri May 24 06:52:30 UTC 2024
@@ -1,3 +1,3 @@
-exit status: 1
+exit status: 0
 
-a different (interactive) test
+just a test
EOF
}
