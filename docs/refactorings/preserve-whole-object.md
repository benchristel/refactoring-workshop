# Preserve Whole Object

This refactoring changes the interface of a method.

It applies when you often find yourself pulling individual
fields out of some object to pass them to the method as
separate arguments.

It would be better to pass the whole object to the method,
so the knowledge of how to get the data out of the object
can live in one place.

## Example

### Before

```ruby
def record(amount, payment_type, cardholder)
  # ...
end

purchase = # ...
record(
  purchase.amount,
  purchase.payment_type,
  purchase.cardholder
)
```

### After

```ruby
def record(purchase)
  amount = purchase.amount
  payment_type = purchase.payment_type
  cardholder = purchase.cardholder
  # ...
end

purchase = # ...
record(purchase)
```

## Next Steps

Often, this refactoring reveals [Feature
Envy](../smells/feature-envy.md). If the method knows about
the data fields of an object, maybe it should live on that
object.
