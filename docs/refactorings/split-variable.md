# Split Variable

Instead of reassigning a variable, give a different name to
each value.

## Example

### Before

```ruby
python_version = 2
if is_red_hat_8?
  python_version = 3
end
```

### After

```ruby
default_python_version = 2
python_version =
  if is_red_hat_8?
    3
  else
    default_python_version
  end
```

## References

- [Split Variable on Refactoring.com](https://refactoring.com/catalog/splitVariable.html)
