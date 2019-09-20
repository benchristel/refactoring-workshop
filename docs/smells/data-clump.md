# Data Clump

## What It Looks Like

A group of variables are all passed around together or used
together.

```ruby
def distance(x1, y1, x2, y2)
  Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
end
```

In this code, `x1` and `y1` form one data clump—they
represent a point in the Cartesian plane. `x2` and `y2` form
another clump.

## Why It Hurts

When a method takes many positional arguments, calls to the
method become difficult to read. It's too easy to pass
arguments in the wrong order, or reference the wrong parameter within the method implementation.

## How To Fix It

Instead of extracting individual fields from an object to pass them to a function, use [Preserve Whole Object](../refactorings/preserve-whole-object.md). If there is no such object, use [Introduce Parameter Object](../refactorings/introduce-parameter-object.md).

```ruby
def distance(a, b)
  Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
end
```

## Next Steps

Often, refactoring this smell away is just a stepping stone
to a bigger refactor. After [Introduce Parameter Object](../refactorings/introduce-parameter-object.md), you may notice that the code has [Feature Envy](feature-envy.md) and should be a method on the parameter object.

After a sequence of such refactorings, the example code above might look like this:

```ruby
class Point < Struct.new(:x, :y)
  def distance(other)
    dx = x - other.x
    dy = y - other.y
    Math.sqrt(dx ** 2 + dy ** 2)
  end
end
```
