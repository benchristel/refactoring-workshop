# Missing Editing Affordance

In user experience design, an _affordance_ is a property
of the designed object that suggests a particular
interaction.

> ...the term _affordance_ refers to the perceived and
> actual properties of the thing, primarily those
> fundamental properties that determine just how the thing
> could possibly be used. [...] Affordances provide strong
> clues to the operations of things. Plates are for pushing.
> Knobs are for turning. Slots are for inserting things
> into.
>
> Donald Norman, _The Psychology of Everyday Things_, p. 9

I define an _editing affordance_ as a property of code that
suggests to the programmer how to change it.

## What It Looks Like

This shell code has few editing affordances. It is not
immediately clear where to add new code, and what the
resulting relationship of that new code would be to its
surroundings.

```bash
TOPLEVEL="$1"
set -exo pipefail
source /opt/gcc_env.sh
source "${TOPLEVEL}/utils/testing.sh"
pushd "${TOPLEVEL}/src/test/regression"
SUITE="$2"
bash test.sh "$SUITE"
popd
set +x
```

## The Fix

Whitespace is a powerful editing affordance. Often, blank
lines and indentation ([Rearrange
Whitespace](../refactorings/rearrange-whitespace.md)) are
enough to fix this smell.

Here's a better version of the code above:

```bash
set -eo pipefail

TOPLEVEL="$1"
SUITE="$2"

set -x
  source /opt/gcc_env.sh
  source "${TOPLEVEL}/utils/testing.sh"

  pushd "${TOPLEVEL}/src/test/regression"
    bash test.sh "$SUITE"
  popd
set +x
```

The code now communicates:
- where to add a new positional argument to the script
- where to `source` a new file of helper functions
- where to add code that needs to run in the
  `src/test/regression` directory
- where to add code that should be logged with `-x`

and it does so without saying a single extra word!
