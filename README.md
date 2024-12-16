# Execution Marker

_Records (and later retrieves) the (time of the) execution of a command (with an optional CONTEXT)._

This small tool records the time (of a _subject_, which is something that happens; typically the execution of a command), and optionally also some _context_ information along with it. Assuming infrequent access by default, file locking can be optionally enabled to safely handle concurrent updates, as well as simple transactions.

It can then be queried whether the subject has been recorded already (and, more important, the _time difference_ to when it last happened).

## Dependencies

* [inkarkat/miniDB](https://github.com/inkarkat/miniDB)
* [inkarkat/shell-basics](https://github.com/inkarkat/shell-basics) for the `withOutputDiffToPreviousExecution` command
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

## Simple cache implementation

Together with the _context_, this makes it easy to implement a simple cache: Query for a command's context, if it's been updated within the last _N_ seconds, then either return the cached data, or execute the command and record its execution and output.

    if output="$(executionMarker --query "$command" --within "$interval" --get-context)"; then
        # Within the interval, reuse cached output.
        :
    else
        # Regenerate stale output and update the execution context with it
        # for recalling on the next invocations within the interval.
        #
        # As the next call may already happen before the output creation has
        # finished (and the execution marker is only created after creation
        # finished and all output has been read), multiple concurrent updates
        # could be triggered. To prevent that, create an initial dummy marker /
        # update the timestamp prior to the actual update.
        if executionMarker --query "$command"; then
            executionMarker --update "$command" --keep-context
        else
            executionMarker --update "$command" --context "(${command}: Initial run; no data yet.)"
        fi

        output="$("$command" 2>&1)"
        if [ $? -eq 99 ]; then
            # Special signal that the source is temporarily unavailable, the
            # previous output should be recalled, and the command retried
            # immediately on the next iteration, not only after the next
            # interval.
            executionMarker --query "$command" --get-context &&
                executionMarker --update "$command" --keep-context --timestamp 1
        else
            executionMarker --update "$command" --context "$output"
        fi
    fi
