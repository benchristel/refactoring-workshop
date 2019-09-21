# Replace Loop With Pipeline

Separate data transformation from side effects by replacing
an imperative loop with a sequence of functional operations.

## Example

### Before

```ruby
sessions.each do |token|
  if session.token != current_session.token
    session.token.expire!
  end
end
```

### After

```ruby
sessions.map(&:token)
  .reject { |t| t == current_session.token }
  .each(&:expire!)
```
