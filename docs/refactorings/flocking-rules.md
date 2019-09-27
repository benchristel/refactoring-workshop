# The Flocking Rules

These rules come from the book [_99 Bottles of
OOP_](https://www.sandimetz.com/99bottles) by Sandi Metz and Katrina Owen.
The term "flocking" is a reference to the emergent behavior of flocks of birds
and schools of fish: by following a few simple rules, these animals move in highly
coordinated-looking groups. Metz and Owen argue that complex-looking software designs
can emerge organically if you follow the Flocking Rules for removing duplication from
code.

The rules form a procedure for removing duplication:

1. Find the things that are most alike.
2. Select the smallest difference between them.
3. Make the smallest change that will remove that difference.

By applying this procedure repeatedly, you can remove almost all the duplication
from your code.

## Example

### Before

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

Here's the message `"Greetings, #{name}"` is duplicated, so it's tempting to extract a variable
or method for it. But that doesn't help much:


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

Now we have not only duplication, but indirection: you have to mentally dereference `greeting` to
read this code. The `greeting` variable is still duplicated.

### After

Applying the Flocking Rules leads us to a different solution:

1. **Find the things that are most alike.**
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
    In this case, the lines `Email.mail greeting` and `Slack.post greeting` are
    the most alike.

1. **Select the smallest difference between them.**
    The smallest difference is the method name: `mail` vs. `post`.

1. **Make the smallest change that will remove that difference.**
    Rename the method.
    ```ruby
    def greet(message_type, name)
      case message_type
      when :email
        Email.post "Greetings, #{name}"
      when :slack
        Slack.post "Greetings, #{name}"
      end
    end
    ```

1. **Find the things that are most alike.**
    Still the same lines: `Email.post` vs. `Slack.post`

2. **Select the smallest difference between them.**
    The smallest difference is the class name: `Email` vs. `Slack`.

3. **Make the smallest change that will remove that difference.**
    We obviously can't rename the classes to be the same, so we
    have to extract a variable:
    ```ruby
    def greet(message_type, name)
      case message_type
      when :email
        messenger = Email
        messenger.post "Greetings, #{name}"
      when :slack
        messenger = Slack
        messenger.post "Greetings, #{name}"
      end
    end
    ```
    At first glance, this looks kind of silly. We've added indirection without
    fixing duplication! But now, magic happens. We now have two lines that
    are identical, and that exact duplication simply evaporates:
    ```ruby
    def greet(message_type, name)
      case message_type
      when :email
        messenger = Email
      when :slack
        messenger = Slack
      end
      messenger.post "Greetings, #{name}"
    end
    ```

That's as far as the Flocking Rules will take us, unless we're willing to make a leap of
Ruby insight and do:

```ruby
def greet(message_type, name)
  messenger =
    case message_type
    when :email
      Email
    when :slack
      Slack
    end
  messenger.post "Greetings, #{name}"
end
```

which allows us to remove the duplicated assignment to `messenger`.
