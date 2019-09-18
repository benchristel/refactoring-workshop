# Commented-out Code

## What It Looks Like

```ruby
# users.each do |u|
#   puts u.inspect
# end
```

## Why It Hurts

Commenting out code is a risky way of keeping
temporarily-unused functionality around. Since you can't
test it, how do you know it will still work when you
uncomment it?

## How To Fix It

In my experience, commented-out code rarely comes back to
life, so the best thing to do is [delete
it](../refactorings/remove-comment.md). If the code is truly
useful, e.g. as development instrumentation, it should be
tested, factored out... and then disabled in production with
a feature flag or dependency injection.

## Caveats

TODO
