# Replace Primitive With Object

## Example

### Before

```ruby
def protocol(url_string)
  url_string.match(/^([^:]+):/)[1]
end
```

### After

```ruby
def protocol(url)
  url.scheme
end

# ... elsewhere ...

url = URI.parse(url_string)
```
