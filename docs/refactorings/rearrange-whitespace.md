# Rearrange Whitespace

## Example

### Before

```ruby
def foo bar
1 + bar
end
 def baz(kludge)
     2+kludge
     end
```

### After

```ruby
def foo(bar)
  1 + bar
end

def baz(kludge)
  2 + kludge
end
```
