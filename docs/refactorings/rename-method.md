# Rename Method

## Example

### Before

```ruby
def foo(a, b)
  (a + b) / 2.0
end

foo(37, 99)
```

### After

```ruby
def average(a, b)
  (a + b) / 2.0
end

average(37, 99)
```

## References

- [Rename Method on Refactoring.com](https://refactoring.com/catalog/changeFunctionDeclaration.html)
