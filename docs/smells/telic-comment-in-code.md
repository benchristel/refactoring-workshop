# Telic Comment In Code

## What It Looks Like

"Telic" means "relating to goals or purpose". A *Telic Comment* is a comment that expresses why a particular
bit of code was written.

```ruby
# Support windows paths; customer X has servers running
# Windows for application Y.
if path.include? "\\"
  components = path.split("\\")
else
  components = path.split("/")
end
```

## Why It Hurts

Tests, not code, should be used to communicate *why* a bit of functionality was added, because we want the code to
be refactorable at any time. If we have to keep the code just so in order to be able to trace the reason why a change
was made, we'll be afraid to refactor and it will be much harder to make changes.

## How To Fix It

Use [Move Telic Comment To Test](../refactorings/move-telic-comment-to-test.md).

## Caveats
