# Null Check

## What It Looks Like

```ruby
button_text =
  if current_user.nil?
    "Sign In"
  else
    "Sign Out"
  end
```

```ruby
most_recent_purchase = purchases.last
if most_recent_purchase.nil?
  raise NoPurchases.new
end
```

## Why It Hurts

Null checks (or `nil` checks in ruby) are a special case
of [Primitive Obsession](primitive-obsession.md). Sometimes,
code involving a nil value has [Feature
Envy](feature-envy.md), where we'd like to move logic into
the nil type so it can play the same role as other objects
in the system. We shouldn't do this, of course, because
`nil` is a built-in object that gets used in many different
contexts.

## How To Fix It

[Introduce Null
Object](../refactorings/introduce-null-object.md).

When `nil` indicates an error, nonexistent result, or other
special case, use [Introduce
Continuation](../refactorings/introduce-continuation.md) to
let the caller specify what should happen in that special
case.

## Caveats

Beware of introducing null-object stand-ins for value
objects, i.e. objects whose primary purpose is to represent
data. The use of such objects can lead to absurdities:

```ruby
queue = []
last = items.last
queue << last unless last.nil?
queue.empty?
```

If `items.last` returns `nil` when `items` is empty, then
whenever `items` is empty, `queue` will be empty. If,
however, `items.last` returns a Null Object, then the queue
will contain a single, meaningless object, which may be
wrong for our application. We could of course replace the
`nil?` check by implementing a special method on our value
objects:

```ruby
queue = []
last = items.last
queue << last unless last.is_null_object?
queue.empty?
```

but this just complicates the system without really
clarifying anything.

Applying the Tell, Don't Ask principle can help us here:

```ruby
queue = []
last = items.last
last.add_to(queue)
queue.empty?
```

Now the Null Object is free to implement `add_to` by doing
nothing.

It's up to you to decide whether this is any better.
