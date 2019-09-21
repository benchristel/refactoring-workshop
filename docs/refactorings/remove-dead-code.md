# Remove Dead Code

## Example

### Before

```ruby
message = "hello"
unless message.nil?
  puts message
end
```

### After

```ruby
message = "hello"
puts message
```
