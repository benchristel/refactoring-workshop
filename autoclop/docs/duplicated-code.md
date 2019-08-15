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

However, one of the most valuable de-duplication techniques
I've learned is the algorithm that Sandi Metz calls
"the Flocking Rules".

## The Flocking Rules for Removing Duplication

Katrina Owen describes the rules in [this conference
talk](https://www.youtube.com/watch?v=-wYLmsizBc0). They go
like this:

> 1. Find the things that are most alike.
> 2. Select the smallest difference between them.
> 3. Make the smallest change that will remove that difference.

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

Consider the following example of code that contains
duplication:

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

Since the message is duplicated in this example, it's tempting
to extract a `greeting` variable:

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

But that doesn't help the situation much. The new code
contains more indirection, and there's still duplication of
the reference to `greeting`. True, it's now less likely that
the email and slack messages will get out of sync, but it's
harder to see what behavior will be affected by changes to
the message string, because of the indirection.

## Applying the Flocking Rules

Here's a refactoring that *does* completely remove the
duplication:

```ruby
def greet(message_type, name)
  messenger(message_type).call "Greetings, #{name}"
end

def messenger(type)
  case type
  when :email
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
    when :email
      Email
    when :slack
      Slack
    end
  end
end
```

How can we refactor toward this code, using the flocking
rules?

Going back to the original code: we first identify the
most similar chunks. These are the lines that create the
`"Greetings, #{name}"` message.

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

Rather than focusing on the similar parts, we focus on
the difference: `Email.mail` versus `Slack.post`.

We extract the parts that differ, aiming only to make the
similar lines look *exactly* the same. We don't yet remove
any duplication.

```ruby
def greet(message_type, name)
  case message_type
  when :email
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
  when :email
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
  when :email
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
  when :email
    klass = EmailMessenger
    messenger = ->(msg) { klass.post msg }
  when :slack
    klass = Slack
    messenger = ->(msg) { klass.post msg }
  end
  messenger.call "Greetings, #{name}"
end
```

Now we once again have duplicated lines inside a conditional
(the `messenger = ->(msg) { klass.post msg }` lines).
We can deduplicate them by moving one copy outside the
conditional.

```ruby
class EmailMessenger
  # ...
end

def greet(message_type, name)
  case message_type
  when :email
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
class EmailMessenger
  # ...
end

def greet(message_type, name)
  case message_type
  when :email
    klass = EmailMessenger
  when :slack
    klass = Slack
  end
  klass.post "Greetings, #{name}"
end
```

We can also move the duplicated `klass =` outside the
`case` statement. In Ruby, `case` statements are actually
expressions that return a value. Unfortunately, there aren't
really any intermediate steps that can guide us here; this
is one of those refactorings you just have to know.

I also rename the variable from `klass` to `messenger` in
this step, because I think having to misspell `class` in
variable names is awkward.

```ruby
def greet(message_type, name)
  messenger = case message_type
    when :email
      EmailMessenger
    when :slack
      Slack
    end
  messenger.post "Greetings, #{name}"
end
```

Now all the duplication is gone. There are other code
smells; for instance, the `message_type` is an example of
primitive obsession, and the `greet` method now clearly has
multiple responsibilities (choosing a class and `post`ing a
message). Other refactorings could remove these smells, but
they are outside the scope of this discussion.

## Should You Do This In Real Life?

You might react to the above refactoring example by saying
that it's overkill. There isn't a very compelling reason to
remove such small, local bits of duplication using the
flocking rules, especially when there are only two
duplicated copies.

However, it's still worth *practicing* these refactorings on
small, simple examples, so that when you see complicated
code at work, you know what to do.

## Preserving and Extending Symmetries

Imagine, for a minute, how the code in the previous section
might change if we added a new requirement: if `:all` is
passed as the `message_type` to `greet`, we must send both
a Slack message and an email.

As a first attempt, we might view this new requirement as
a special case, and implement it like this:

```ruby
def greet(message_type, name)
  message = "Greetings, #{name}"
  case message_type
  when :all
    Email.post message
    Slack.post message
    return
  when :email
    messenger = Email
  when :slack
    messenger = Slack
  end
  messenger.post message
end
```

But now the code for `:all` looks totally different from the
code for `:email` and `:slack`. Does `:all` really warrant
such special handling?

To remove the special casing, we could refactor to this:

```ruby
def greet(message_type, name)
  case message_type
  messengers = when :all
      [Email, Slack]
    when :email
      [Email]
    when :slack
      [Slack]
    end
  messengers.each { |m| m.post "Greetings, #{name}" }
end
```

Or we could have written this right off the bat, with no
refactoring required:

```ruby
class EmailAndSlackMessenger
  def self.post(msg)
    Email.post msg
    Slack.post msg
  end
end

def greet(message_type, name)
  messenger = case message_type
    when :all
      EmailAndSlackMessenger
    when :email
      Email
    when :slack
      Slack
    end
  messenger.post "Greetings, #{name}"
end
```

Or, combining the two approaches:

```ruby
class MultiMessenger < Struct.new(:messengers)
  def post(msg)
    messengers.each { |m| m.post msg }
  end
end

def greet(message_type, name)
  messenger = case message_type
    when :all
      MultiMessenger.new([Email, Slack])
    when :email
      Email
    when :slack
      Slack
    end
  messenger.post "Greetings, #{name}"
end
```

Personally, I like the second design best in this
context. It preserves more of the structure of the existing
code. However, if I didn't know the history of the code, I
might prefer the first or third solution.

One result of removing duplication using the Flocking Rules
is that you end up with very "symmetrical" code. I call code
symmetrical when it's either totally unique (like the
`messenger.post "Greetings, #{name}"` line in the example
above), or a repeated rhythm of lines that are identical in
structure but different in content (like the `case`
statement).

As you add more behavior to symmetrical code, it's worth
making an effort to preserve the symmetry. That is, if you
add a new branch to the case statement, it should have the
same syntactic structure as the other branches. The
consistency of structure helps the next person who has to
read your code focus on the differences that matter, without
getting distracted by extraneous syntactic variation.

I'll leave you to ponder this quote (from architect
Christopher Alexander), which I think applies equally well to
architecture and code.

> Complexity (in the bad sense) consists of distinctions which unnecessarily complicate a structure. To get simplicity, on the other hand, we need a process which questions every distinction. Any distinction which is not necessary is removed. To remove a distinction we replace it by a symmetry.
>
> —Christopher Alexander, _The Process of Creating Life_, p. 469
