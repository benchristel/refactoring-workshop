# Explanatory Comment

## What It Looks Like

```ruby
# ignore users with no purchases
final_users = []
for user in users
  next if user.purchases.empty?
  final_users << user
end
```

## Why It Hurts

Comments that reiterate what should be clear from the code
are a smell, because they almost certainly indicate that
the code itself is not as expressive or clear as it could
be. Since comments often go out of date, people still have
to read the code to determine if the comment is correct.

## How To Fix It

Use [Remove Comment](../refactorings/remove-comment.md)
combined with [Extract Method](../refactorings/extract-method.md) or
[Replace Inline Code with Function Call](../refactorings/replace-inline-code-with-function-call.md).

## Caveats
