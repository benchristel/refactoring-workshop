# Introduce Null Object

## Example

### Before

```ruby
username =
  if current_user.nil?
    "Guest"
  else
    current_user.name
  end
```

### After

```ruby
username = current_user.name

# ...

class LoggedInUser
  def name
    @name
  end

  # ...
end

class GuestUser
  def name
    "Guest"
  end

  # ...
end
```

## References

Sandi Metz has a great video about the Null Object Pattern
in Ruby, titled [Nothing is
Something](https://www.youtube.com/watch?v=OMPfEXIlTVE).
