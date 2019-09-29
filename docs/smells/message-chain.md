# Message Chain

Code traverses the object graph, sending messages not only
to its immediate collaborators but to the collaborators of
those collaborators.

Also known as a "Train Wreck" or "Law of Demeter Violation".

## What It Looks Like

```ruby
def shipment_delivered?
  !shipment.delivery_date.to_s.strip.empty?
end
```

## Why It Hurts

Dependencies on transitive collaborators make code brittle.
Changes to any object involved in the message chain can
break the code that's sending the messages. In addition,
it's painful to mock transitive collaborators in unit tests.

## How To Fix It

Similar to [Feature Envy](feature-envy.md): Use [Move
Method](../refactorings/move-method.md) and
[Extract Method](../refactorings/extract-method.md). If you
have deeply nested data objects, you may have to flatten
a [Deep Hierarchy](deep-hierarchy.md).

## Caveats

The Builder Pattern results in message chains, but these
are not harmful; since each method returns `self`, you're
always talking to the same object.
