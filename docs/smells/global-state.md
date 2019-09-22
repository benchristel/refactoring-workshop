# Global State

Different parts of the program have access to a shared,
mutable resource.

## What It Looks Like

```ruby
def profile_page
  $current_user = get_logged_in_user
  render_profile_page
end
```

Here, not only is there an explicit global variable
`$current_user`, but there is implicit global state:
`get_logged_in_user` probably accesses a database, and
`render_profile_page` probably sends an HTTP response.

Whenever a resource—whether a filesystem, the network, a
database, or a chunk of memory—changes state over time and
can be accessed by any part of the program, you have global
state.

## Why It Hurts

[Contributors to the C2Wiki have
identified](http://wiki.c2.com/?GlobalVariablesAreBad) a
number of reasons why global state is bad:

- **Non-locality:** Different parts of the program may
  affect each other through global resources, causing
  nightmarish bugs. This is sometimes called "spooky action
  at a distance."
- **No Access Control:** Since any part of the program may
  access global state, it is very difficult to enforce
  constraints on its use. Third-party plugins may be able to
  access the global state, compromising security.
- **Implicit Coupling:** Global variables often form logical
  groupings, but since they're not members of an object,
  those relationships are invisible.
- **Concurrency Issues:** Multiple threads can access a
  global, resulting in non-deterministic bugs.
- **Namespace Pollution:** Global variables from different
  modules can collide, causing one module's data to
  overwrite another's.
- **Testing:** Global state makes it hard to set up a clean
  environment for the system under test.

## How To Fix It

Use [Inject Global
State](../refactorings/inject-global-state.md) to explicitly
declare dependencies on global resources, and break the
coupling between your code and the global. If your code is
setting global variables, use [Return Modified
Value](../refactorings/return-modified-value.md) to
communicate the updated values back to the caller.

## Caveats

### Infinite Regress

You can't go on refactoring away global state forever: at
some point, *some* part of your program must access mutable,
global resources. In a functional language, this part may
be built into the language runtime, so you don't have to
write the code yourself. But ideally, the section of your
program that accesses global state directly should be small
and clearly demarcated.

### Constants

Global state is not to be confused with global *constants*,
which are not nearly as harmful because they cannot change
over time. Of the above problems with global state, only
namespace pollution applies to constants.

Thus, it's relatively harmless to declare:

```ruby
Math::PI = 3.141592653589793
```

and in fact the Ruby standard library does so.
