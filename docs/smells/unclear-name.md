# Unclear Name

## What It Looks Like

```
irec = zadd(raw)
```

## Why It Hurts

When names are opaque, ambiguous, or unspecific, you can't
tell what effect your changes to the code might have.

## How To Fix It

Use [Rename Variable](../refactorings/rename-variable.md)
and [Rename Method](../refactorings/rename-method.md).

Here's a better version of the code above:

```
index_record = ensure_null_byte_at_end(raw_index)
```

## Caveats

Beware of fixing this smell too early. When you're uncertain
about what code is actually doing, giving it a
confident-sounding (but inaccurate) name can mislead future
readers of the code. See Arlo Belshee's post ["Good Naming
Is a Process, Not a Single
Step"](http://arlobelshee.com/good-naming-is-a-process-not-a-single-step/)
for more.
