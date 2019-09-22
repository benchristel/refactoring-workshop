# Return Modified Value

## Example

Here is some server-side code from a website that responds
to a request for the logged-in user's profile page.

### Before

```ruby
def render_profile_page
  me = $current_user
  html = # ...
  # ...
  send_http_response 200, html
end
```

### After

```ruby
def render_profile_page(me)
  me = $current_user
  html = # ...
  # ...
  return 200, html
end
```

## References

- [Return Modified Value on Refactoring.com](https://refactoring.com/catalog/returnModifiedValue.html)
