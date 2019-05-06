#!/bin/bash

export XDG_CONFIG_HOME="$BATS_TMPDIR"
export NOW=1557046730

initialize_config()
{
    [ "$2" = from ] || exit 2
    cp -f "${BATS_TEST_DIRNAME}/config/${3:?}" "${XDG_CONFIG_HOME}/${1:?}"
}

dump_config()
{
    sed >&3 -e 's/^/#/' -- "${XDG_CONFIG_HOME}/${1:?}"
}

get_row_number()
{
    wc -l "${XDG_CONFIG_HOME}/${1:?}" | awk '{ print $1; }'
}

assert_config_row()
{
    [ "$(sed -n -e "${2:?}p" "${XDG_CONFIG_HOME}/${1:?}")" = "${3?}" ]
}