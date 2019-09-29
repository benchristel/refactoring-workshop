# Feature Envy

A method cares more about another object's data than about
its own.

## What It Looks Like

```ruby
def shipment_delivered?
  !shipment.delivery_date.to_s.strip.empty?
end
```

```ruby
def invoice_total
  invoice.parts.map(&:price).reduce(:+) + invoice.labor
end
```

## Why It Hurts

Feature envy may mask [Duplicated Code](duplicated-code.md)
since similar envious code may be repeated in multiple
places. It is often associated with [Message
Chains](message-chain.md), since the envious code asks for
and manipulates another object's data and thus has to know
about the types of those data.

## How To Fix It

Use [Move Method](../refactorings/move-method.md) to move
the envious code to the envied class. You may have to
[Extract Method](../refactorings/extract-method.md) first to
isolate the code that should be moved.

## Related Smells

[Primitive Obsession](primitive-obsession.md) is often a
sign of hidden Feature Envy. If the primitive were replaced
by a class you could modify, you could move the
primitive-obsessed methods to it.
