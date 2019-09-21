# Inline Method

Remove a method declaration by moving the code in the
method's body to its callsites.

## Example

### Before

```ruby
def fraction_of_total(a, b)
  a / (a + b)
end

def foo
  puts fraction_of_total(5, 10)
end
```

### After

```ruby
def foo
  puts 5 / (5 + 10)
end
```

### Next Steps

After you inline a method, sometimes you end up with
constants that can be combined (as in the example above, in
which we're performing the computation `5 / (5 + 10)` with
hardcoded constants). A good follow-up refactoring is
[Compile Constant Value [BC]](compile-constant-value.md).
