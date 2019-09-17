# Inconsistent Formatting

## What It Looks Like

```ruby
def foo(bar)
1 + bar
end
 def baz kludge
   2 + kludge
 end
```

## Why It Hurts

Consistency is important. By making things that are similar appear similar, important differences stand out more.
It is also easier to read a code style you encounter a lot, so being consistent with formatting helps you read code
more quickly and easily.

## How To Fix It

Use [Rearrange Whitespace](../refactorings/rearrange-whitespace.md).

## Caveats

Extremely rigid formatting rules can make code less readable in certain circumstances. Balance consistency with
readability.
