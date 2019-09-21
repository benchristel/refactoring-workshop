# Long Method

A method has many lines, possibly involving conditionals,
loops, variable assignments, and early exits.

## What It Looks Like

```ruby
def some_long_method
  result = ""
  if some(complicated(logic))
    things.each do |thing|
      step1 thing
      step2 thing
      if thing.condition? && something_else?
        modify(result)
      end
    end
    if other_condition?
      raise AnError.new
    end
  else
    stuff.each do |whatever|
      whatever.foo? && whatever.bar? || baz(result)
    end
    result += addendum
  end
  result
end
```

## Why It Hurts

Long methods tend to be hard to understand when they
entangle multiple responsibilities or mutate state. When
reading the code, you have to understand not only what each
line does, but how it interacts with the rest of the
method's code. The difficulty of understanding a method is
thus something like O(n^2) in the method's length.

## How To Fix It

The best fix is to [Replace Inline Code With Function
Call](../refactorings/replace-inline-code-with-function-call.md)—that
is, call other existing methods to implement the logic. If
no suitable helper methods exist, [Extract
Method](../refactorings/extract-method.md) can break up the
long method into more digestible chunks.

## Caveats

When you break up a long method, be sure the pieces you
extract are intelligible in isolation. Otherwise, the code
may become *harder* to read as a result of the refactoring.
For specific antipatterns, see [Idea
Fragment](idea-fragment.md) and [Deep
Hierarchy](deep-hierarchy.md).
