# Duplicated Code

Duplicated Code is one of the easiest code smells to spot,
yet it is surprisingly hard to remove effectively.
Therefore, I think the subject of removing duplication from
code deserves special attention.

The thing that makes duplicated code hard to fix is that the
opposite of duplication, [Once And Only
Once](http://wiki.c2.com/?OnceAndOnlyOnce) or DRY (Don't
Repeat Yourself), is not a concrete pattern, but an abstract
principle. There are many concrete refactorings you have to
learn before you can remove all types of duplication
effectively.

## The Flocking Rules for Removing Duplication

Sandi Metz has a great algorithm for removing duplication,
which Katrina Owen describes in [this conference
talk](https://www.youtube.com/watch?v=-wYLmsizBc0). It goes
like this.

1. Find the things that are most alike.
2. Select the smallest difference between them.
3. Make the smallest change that will remove that difference.

Sandi Metz calls these "flocking rules" because, like the
simple algorithms that birds and fish use to move as a group
while avoiding collisions, they are *generative*. They
produce outcomes that are not explicit in the ruleset.

## Our Less-Effective Instinct

Our natural instinct, when faced with duplication and
instructed to remove it, is to find pieces of code that are
identical and extract them as methods or variables. The
problem with this approach is that it doesn't actually
remove duplication; it merely aliases it.

```ruby
def greet(message_type, name)
  case message_type
  when :html_email
    Email.mail "Greetings, #{name}"
  when :slack
    Slack.post "Greetings, #{name}"
  end
end
```

Since the message is duplicated in this example, it's tempting
to extract a `greeting` method:

```ruby
def greet(message_type, name)
  case message_type
  when :html_email
    Email.mail greeting name
  when :slack
    Slack.post greeting name
  end
end

def greeting(name)
  "Greetings, #{name}"
end
```

But that's a distraction. The new code contains more
indirection, and there's still duplication of the call to
`greeting`. True, it's now less likely that the email and
slack messages will get out of sync, but it's harder to know
what behavior will be affected by changes to `greeting`,
because of the indirection.

Here's a refactoring that *does* completely remove the
duplication:

```ruby
def greet(message_type, name)
  messenger(message_type).call "Greetings, #{name}"
end

def messenger(type)
  case type
  when :html_email
    ->(msg) { Email.mail msg }
  when :slack
    ->(msg) { Slack.post msg }
  end
end
```

If we're allowed to shift some interfaces slightly, we can
simplify this code further. In the example below, `Email`
has been changed to have a `post` method, so it implements
the same interface as `Slack`. The `greet` method's
primitive obsession has been removed; now it takes in a
messenger, instead of a symbol that tells it what messenger
to select.

```ruby
class Greeter
  def greet(messenger, name)
    messenger.post "Greetings, #{name}"
  end
end

class MessengerFactory
  def self.build(type)
    case type
    when :html_email
      Email
    when :slack
      Slack
    end
  end
end
```

How can we arrive at this code, using the flocking rules?

Going back to the original code: we first identify the
most similar chunks. These are the lines that create the
`"Greetings, #{name}"` message.

```ruby
def greet(message_type, name)
  case message_type
  when :html_email
    Email.mail "Greetings, #{name}"
  when :slack
    Slack.post "Greetings, #{name}"
  end
end
```

Rather than focusing on the similar parts, we focus on
the difference: `Email.mail` versus `Slack.post`.

We extract the difference and give it a name, aiming only
to make the duplicated lines look exactly the same. We don't
yet remove any duplication.

```ruby
def greet(message_type, name)
  case message_type
  when :html_email
    messenger = ->(msg) { Email.mail msg }
    messenger.call "Greetings, #{name}"
  when :slack
    messenger = ->(msg) { Slack.post msg }
    messenger.call "Greetings, #{name}"
  end
end
```

Now the `messenger.call` lines are identical, so we can
remove the duplication by moving that line outside the
`case` statement.

```ruby
def greet(message_type, name)
  case message_type
  when :html_email
    messenger = ->(msg) { Email.mail msg }
  when :slack
    messenger = ->(msg) { Slack.post msg }
  end
  messenger.call "Greetings, #{name}"
end
```

Now we've gone around the refactoring loop once. And,
dismayingly, it seems like we haven't made much progress. We
fixed the original duplication but added another pair of
similar looking lines, which construct the `->(msg)`
lambdas.

The difference between these lines is (again) `Email.mail`
versus `Slack.post`.

In order to continue removing duplication, we have to make
`Email` look more like `Slack`. We could change its
interface, but that's going to have ripple effects in other
parts of the codebase, so let's wrap it in an
`EmailMessenger` class instead.

```ruby
class EmailMessenger
  def self.post(msg)
    Email.mail msg
  end
end

def greet(message_type, name)
  case message_type
  when :html_email
    messenger = ->(msg) { EmailMessenger.post msg }
  when :slack
    messenger = ->(msg) { Slack.post msg }
  end
  messenger.call "Greetings, #{name}"
end
```

Now the only part that differs between the duplicated lines
is the name of the class: `EmailMessenger` vs. `Slack`.
We can extract a variable for the class because in Ruby,
classes are objects.

Again, this next step doesn't remove duplication. It just
makes the similar lines look identical.

```ruby
class EmailMessenger
  # ...
end

def greet(message_type, name)
  case message_type
  when :html_email
    klass = EmailMessenger
    messenger = ->(msg) { klass.post msg }
  when :slack
    klass = Slack
    messenger = ->(msg) { klass.post msg }
  end
  messenger.call "Greetings, #{name}"
end
```

Now we once again have duplicated lines inside a conditional,
so we can move them out:

```ruby
class EmailMessenger
  # ...
end

def greet(message_type, name)
  case message_type
  when :html_email
    klass = EmailMessenger
  when :slack
    klass = Slack
  end
  messenger = ->(msg) { klass.post msg }
  messenger.call "Greetings, #{name}"
end
```

And now the `->(msg)` lambda is pointless indirection. So let's
get rid of it:

```ruby
class SlackMessenger
  # ...
end

def greet(message_type, name)
  case message_type
  when :html_email
    klass = Email
  when :slack
    klass = SlackMessenger
  end
  klass.post "Greetings, #{name}"
end
```

Now all the duplication is gone. There are other code
smells; for instance, the `message_type` is an example of
primitive obsession, and the `greet` method now clearly has
multiple responsibilities (choosing a class and `post`ing a
message). Other refactorings will remove these smells, but
they are outside the scope of this discussion.
