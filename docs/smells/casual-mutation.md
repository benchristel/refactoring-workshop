# Casual Mutation

A variable or object is mutated in a way that doesn't
correspond to a state change in the user's mental model of
the program.

## What It Looks Like

Here, the parameters hash and its properties are being
modified throughout the `send_request` method.

```ruby
def send_request(id)
  parameters = {id: id}
  token = # ...
  parameters.token = token
  # ...
  if some_condition?
    parameters.id = other_id
  end
  actually_send_request parameters
end
```

## Why It Hurts

When there are multiple assignments to a variable, you have
to read all the code in that variable's scope to understand
what its value will be at any given point. You have to put
in more effort to understand what the code is doing.

## How To Fix It

Use [Split Variable](../refactorings/split-variable.md) to give different names to different
values. If variables are being updated in a loop, use
[Replace Loop with Pipeline](../refactorings/replace-loop-with-pipeline.md).

## Caveats

Sometimes a `for` loop that mutates variables really is the
simplest way to express a section of logic. Additionally, if
the assignments to the variable are close together and the
method is short, reassignment can be pretty harmless, e.g.:

```ruby
def compute_something(starting_value, foo, bar)
  tmp = starting_value
  tmp = step1 tmp
  tmp = step2 tmp, foo
  tmp = step3 tmp, bar
  tmp
end
```
