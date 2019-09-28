# Primitive Obsession

Code manipulates strings and hashes directly instead of
using domain objects.

## What It Looks Like

```ruby
protocol = url.match(/^([^:]+):/)[1]
```

```ruby
username = user["name"]
```

## Why It Hurts

- Since you can't define new methods on primitive data types
(at least not without causing a great deal of confusion),
logic for manipulating them gets scattered around the
codebase.
- Your code becomes coupled to the underlying
structure of the data, making it harder to test and reason
about.
- You have to think about error cases more often. For
  example, when using a string to represent a URL, you have
  to think about the case where the string is not a
  well-formed URL every time you do something with it.

## How To Fix It

[Replace Primitive With Object](../refactorings/replace-primitive-with-object.md).
