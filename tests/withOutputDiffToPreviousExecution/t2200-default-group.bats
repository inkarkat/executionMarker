#!/usr/bin/env bats

load canned_config

@test "testFunction run without a group uses interactive runtime group" {
    export XDG_RUNTIME_DIR="$BATS_TMPDIR"
    cp --force --recursive "${BATS_TEST_DIRNAME}/config/interactive" "${XDG_RUNTIME_DIR}/"

    run withOutputDiffToPreviousExecution -u -- testFunction
    [ $status -eq 1 ]
    [ "$output" = "--- testFunction Fri 24. May 2024 10:40:00 CEST (in 2 hours)
+++ testFunction Fri 24. May 2024 08:52:30 CEST
@@ -1,3 +1,3 @@
-exit status: 1
+exit status: 0
 
-a different (interactive) test
+just a test" ]
}
