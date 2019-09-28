# Duplicated Code

Statements or expressions are copy-pasted, with minor
variations, in several places.

## What It Looks Like

```ruby
def greet(message_type, name)
  case message_type
  when :email
    Email.mail "Greetings, #{name}"
  when :slack
    Slack.post "Greetings, #{name}"
  end
end
```

## Why It Hurts

When the same concept is represented in multiple places,
it's too easy for the duplicate representations to change
out of sync. When that happens, it becomes unclear which
variations are intentional and which are accidental. Chaos
ensues.

## How To Fix It

Follow the [Flocking
Rules](../refactorings/flocking-rules.md).

*Don't* extract variables or methods for the identical
portions of the duplicated code. While this may feel like
you're making progress, it's a trap. You end up with code
like this:

```ruby
def greet(message_type, name)
  greeting = "Greetings, #{name}"
  case message_type
  when :email
    Email.mail greeting
  when :slack
    Slack.post greeting
  end
end
```

Here, we've replaced the message string with the variable
`greeting`. This doesn't remove the duplication; it merely
creates an alias for part of it. In the process, we
introduced indirection, which makes the code harder to
understand.

## Caveats

Sandi Metz says, "Duplication is far cheaper than the wrong
abstraction." A little bit of duplication is fine,
especially if it's within one class or method. Writing more
abstract code to remove the duplication can actually make
code harder to understand when you haven't accurately
identified the concept underlying the duplicated code.

When de-duplicating code, adhere to [Preserve Whole
Object](../refactorings/preserve-whole-object.md). Keeping
objects and values whole takes priority over removing all
duplication.

Here's an example where whole values weren't preserved:

```ruby
button_text = "Sign " +
  if current_user.nil?
    "In"
  else
    "Out"
  end
```

How much clearer is this?

```ruby
button_text =
  if current_user.nil?
    "Sign In"
  else
    "Sign Out"
  end
```
