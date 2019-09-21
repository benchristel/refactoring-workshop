# Inline Method

Remove a method declaration, copying the code in the
method's body to its callsites.

## Example

### Before

```ruby
def greeting(name)
  "Hello, " + name
end

puts greeting "World"
```

### After

```ruby
puts "Hello, " + "World"
```

### Next Steps

After you inline a method, sometimes you end up with
constants that can be combined (as in the example above, in
which we're performing the computation `5 / (5 + 10)` with
hardcoded constants). A good follow-up refactoring is
[Compile Constant Value [BC]](compile-constant-value.md).
