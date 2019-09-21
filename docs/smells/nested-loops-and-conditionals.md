# Nested Loops And Conditionals

Also known as the ["Arrow Anti-Pattern"](http://wiki.c2.com/?ArrowAntiPattern).

## What It Looks Like

```ruby
if logged_in?
  tokens.each do |token|
    if token != current_session.token
      token.expire!
    end
  end
end
```

## Why It Hurts

Code in loops and conditionals tends to conflate data
transformation with side effects. This is because there's no
way for a loop or an `if` to affect the rest of the
system unless it has a side effect. As a result, it's hard
to see at a glance what the code is doing, and where it
might be unsafe to insert new code or reorder statements.

## How To Fix It

Use [Replace Loop with
Pipeline](../refactorings/replace-loop-with-pipeline.md) to
separate data transformation from side effects.
Additionally, [Replace Inline Code with Function
Call](../refactorings/replace-inline-code-with-function-call.md)
and [Extract Method](../refactorings/extract-method.md) can
help abstract away complex boolean logic in conditionals.

## References

- [ArrowAntiPattern on C2Wiki](http://wiki.c2.com/?ArrowAntiPattern)
