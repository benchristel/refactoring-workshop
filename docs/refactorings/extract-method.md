# Extract Method

## Example

### Before

```ruby
if Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2) < THRESHOLD
  # ...
end
```

### After

```ruby
if distance(a, b) < THRESHOLD
  # ...
end

# ...
def distance(a, b)
  Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
end
```

## References

- [Extract Method on Refactoring.com](https://refactoring.com/catalog/extractFunction.html).
- [Extract Method on Refactoring.guru](https://refactoring.guru/extract-method)
