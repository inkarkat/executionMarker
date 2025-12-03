#!/usr/bin/env bats

load canned_config

@test "query prints formatted time difference of foo subject" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-diff '%R'
    assert_output '2 seconds ago'
}

@test "query prints formatted time difference of foo subject together with context and timestamp" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-context --get-diff 'last was %s' --get-timestamp
    assert_output - <<'EOF'
More foo for me.
last was 2 seconds ago
1557046728
EOF
}

@test "query prints formatted time difference of fox subject together with formatted time and --within 10" {
    type -t reldate >/dev/null || skip 'reldate is not available'
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --get-time '%F' --within 10 --get-diff '%2r'
    assert_output - <<'EOF'
2019-05-05
2m and 13s ago
EOF
}

@test "query prints fallback-formatted time difference of fox subject together with formatted time and --within 10" {
    RELDATE=doesNotExist run -1 executionMarker --timestamp "$NOW" --group samples --query fox --get-time '%F' --within 10 --get-diff '%2r'
    assert_output - <<'EOF'
2019-05-05
133s ago
EOF
}
