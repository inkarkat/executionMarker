#!/usr/bin/env bats

load canned_config

@test "non-existing subject query fails" {
    run -4 executionMarker --group samples --query notInHere
    assert_output ''
}

@test "existing subject can be queried" {
    run -0 executionMarker --group samples --query foo
    assert_output ''
}

@test "non-existing subject query of context fails" {
    run -4 executionMarker --group samples --query notInHere --get-context
    assert_output ''
}

@test "context of existing subject can be queried" {
    run -0 executionMarker --group samples --query foo --get-context
    assert_output 'More foo for me.'
}

@test "non-existing subject query of timestamp fails" {
    run -4 executionMarker --group samples --query notInHere --get-timestamp
    assert_output ''
}

@test "timestamp of existing subject can be queried" {
    run -0 executionMarker --group samples --query foo --get-timestamp
    assert_output '1557046728'
}

@test "context and timestamp of existing subject can be queried" {
    run -0 executionMarker --group samples --query foo --get-context --get-timestamp
    assert_output - <<'EOF'
More foo for me.
1557046728
EOF
}

@test "context and timestamp of existing subject can be queried in the order of options" {
    run -0 executionMarker --group samples --query foo --get-timestamp --get-context
    assert_output - <<'EOF'
1557046728
More foo for me.
EOF
}
