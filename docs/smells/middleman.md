# Middleman

A class or method just forwards messages to some other
object.

## What It Looks Like

```ruby
def invoice_total
  @invoice.total
end
```

## Why It Hurts

Extra indirection costs you time and effort as you read
code. If you can remove it, perhaps you should.

## How To Fix It

[Inline Method](../refactorings/inline-method.md)

## Caveats

Some design patterns look a lot like middlemen, for example
the Decorator pattern. Don't introduce asymmetry or
duplication for the sake of removing indirection.
