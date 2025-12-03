#!/usr/bin/env bats

load canned_config
export TZ=Etc/UTC

@test "query prints formatted time of foo subject" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-time '%F %T'
    assert_output '2019-05-05 08:58:48'
}

@test "query prints formatted time of foo subject together with context and timestamp" {
    run -0 executionMarker --timestamp "$NOW" --group samples --query foo --get-context --get-time '%F %T' --get-timestamp
    assert_output - <<'EOF'
More foo for me.
2019-05-05 08:58:48
1557046728
EOF
}

@test "query prints formatted time of fox subject together with --within 10" {
    run -1 executionMarker --timestamp "$NOW" --group samples --query fox --within 10 --get-time 'time is %T'
    assert_output 'time is 08:56:37'
}

