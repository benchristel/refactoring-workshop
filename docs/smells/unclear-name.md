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
