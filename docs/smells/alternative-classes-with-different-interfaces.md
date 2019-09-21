# Alternative Classes With Different Interfaces

Classes thwart your attempts at duck-typed polymorphism by
implementing similar functionality via slightly different
interfaces.

## What It Looks Like

In this example, you might want to be able to swap out one
type of notification object for another, but you can't do
it—because the interface for sending a notification is
different for each class.

```ruby
class PushNotification
  def emit(message)
    # ...
  end
end

class SlackMessageNotification
  def post(message)
    # ...
  end
end
```

## Why It Hurts

When classes implement similar functionality with different
interfaces, callers of those classes must couple their
implementations to one specific interface. The result is
code that is more rigid: you can't easily swap out one
class for an alternative, because all the interfaces are
different.

## How To Fix It

Use [Rename Method](../refactorings/rename-method.md) and
its friends in the [Change Function
Declaration](https://refactoring.com/catalog/changeFunctionDeclaration.html)
cluster, until the interfaces are the same.
