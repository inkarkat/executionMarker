#!/bin/bash

export XDG_CONFIG_HOME="$BATS_TMPDIR"

initialize_config()
{
    [ "$2" = from ] || exit 2
    cp -f "${BATS_TEST_DIRNAME}/config/${3:?}" "${XDG_CONFIG_HOME}/${1:?}"
}

dump_config()
{
    sed >&3 -e 's/^/#/' -- "${XDG_CONFIG_HOME}/${1:?}"
}

assert_config_row()
{
    [ "$(sed -n -e "${2:?}p" "${XDG_CONFIG_HOME}/${1:?}")" = "${3?}" ]
}
