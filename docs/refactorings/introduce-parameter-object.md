# Introduce Parameter Object

This refactoring changes the interface of a method.

It applies when the method has a large number of parameters
that form one or more logical groupings.

It would be better to pass fewer objects that group the data
together. This would allow people reading the code to more
easily verify that the arguments are passed correctly.

## Example

### Before

```ruby
def distance(x1, y1, x2, y2)
  # ...
end

distance(-1, 2, 3, 5)
```

### After

```ruby
def distance(a, b)
  # ...
end

distance(Point.new(-1, 2), Point.new(3, 5))
```

## Next Steps

Often, this refactoring reveals [Feature
Envy](../smells/feature-envy.md). If the method deals
primarily with data from its parameter object, maybe it
should live on that object.
