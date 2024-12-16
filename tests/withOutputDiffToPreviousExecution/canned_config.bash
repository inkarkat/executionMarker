#!/bin/bash

export XDG_DATA_HOME="$BATS_TMPDIR"
export NOW=1716533550
export LC_ALL=C TZ=Etc/UTC

cannedConfigSetup()
{
    cp --force --recursive "${BATS_TEST_DIRNAME}/config/samples" "${XDG_DATA_HOME}/"
}
setup()
{
    cannedConfigSetup
}

testFunction()
{
    echo 'just a test'
}
export -f testFunction

newFunction()
{
    printf 'this is all\nbrand new\n'
}
export -f newFunction

previouslyFailingFunction()
{
    echo 'flaky'
}
export -f previouslyFailingFunction

previouslySucceedingFunction()
{
    echo >&2 'new problem'
    return 42
}
export -f previouslySucceedingFunction
