# Dead Code

_Dead Code_ is code that has no effect. It can be removed
without impacting the behavior of the system.

## What It Looks Like

Dead code takes many forms.

A condition that's always false:

```ruby
items = []
if items.any?
  do_something
end
```

A condition that's always true:

```ruby
message = "hello"
unless message.nil?
  puts message
end
```

A variable that's unused:

```ruby
def average(a, b)
  sum = a + b
  (a + b) / 2.0
end
```

A method that's never called:

```ruby
def foo
  false
end
```

Dead code is easiest to spot when it's a whole line or
multiple lines, but sometimes a single subexpression can be
dead. For example:

```ruby
if transactions.empty? || transactions.all?(&:complete?)
  # ...
end
```

Here, the `empty?` check is not needed, because `all?`
returns `true` when the collection is empty.

## Why It Hurts

Code that's not needed is waste. Imagine painstakingly
trying to understand some code, or perhaps even refactoring
it, and then finding out that it's not used!

## How To Fix It

Use [Remove Dead Code](../refactorings/remove-dead-code.md).
