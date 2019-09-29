# Deep Hierarchy

The function call graph of a section of code is a deep tree,
e.g.

```
       A
      / \
     B   C
    / \
   D   E
  / \
 F  G
```

The functions have confusing names. It's not clear how
responsibilities are divided among them.

## What It Looks Like

```ruby
def notify_user(id)
  user = user_database.fetch(id)
  send_notification(user)
end

def send_notification(user)
  build_and_send_notification("Hello!", user)
end

def build_and_send_notification(message, user)
  Notifier.deliver Notification.new(message, user)
end

# ...

class Notifier
  # ...
```

## Why It Hurts

Deep call hierarchies often occur because someone wanted to
extract a bunch of small methods, but didn't create any new
abstractions. Indirection without abstraction is painful,
because you have to follow the intent of the code through
every method to understand what's going on.

## How To Fix It

Use [Inline Method](../refactorings/inline-method.md) to get
rid of the indirection. Then use the [Flocking
Rules](../refactorings/flocking-rules.md) to remove any
duplication.

## Related Smells

Deep call hierarchies produce confusing method names,
similar to [Idea Fragments](idea-fragment.md).

Deep hierarchies of other kinds (inheritance, data nesting,
[control flow structures](nested-loops-and-conditionals.md))
are also smelly.
