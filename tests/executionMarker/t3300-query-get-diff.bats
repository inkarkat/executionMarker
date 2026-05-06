#!/usr/bin/env bats

load canned_config

@test "query prints formatted time difference of foo subject" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-diff --output precise --long-units
    assert_output '2 seconds ago'
}

@test "query prints formatted time difference of foo subject together with context and timestamp" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-context --get-diff --output precise --long-units --prefix 'last was ' --get-timestamp
    assert_output - <<'EOF'
More foo for me.
last was 2 seconds ago
1557046728
EOF
}

@test "query prints formatted time difference of fox subject together with formatted time and --newer 10" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --get-time '%F' --newer 10 --get-diff --output precise
    assert_output - <<'EOF'
2019-05-05
2m 13s ago
EOF
}
