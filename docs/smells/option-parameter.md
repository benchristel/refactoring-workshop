# Option Parameter

A method has the information needed to make a decision, but
doesn't act on it. Instead, it passes the information to
some other method via an Option Parameter, and demands that
the *other* method act on it.

When a method takes an Option Parameter, it's a sure sign
that the method has [Multiple
Responsibilities](multiple-responsibilities.md) that should
be separated.

## What It Looks Like

In the code below, the `capitalize` parameter to `container`
is an Option Parameter.

```ruby
def line_of_song(n)
  "#{container(n, true)} of beer on the wall, #{container(n)} of beer."
end

def container(count, capitalize = false)
  string =
    case count
    when 0
      "no more bottles"
    when 1
      "one more bottle"
    else
      "#{count} bottles"
    end

  if capitalize
    string.capitalize
  else
    string
  end
end
```

## Why It Hurts

In the example above, the `how_many` method has been
assigned too many responsibilities. The capitalization logic
should properly live in `line_of_song`, which knows when the
strings should be capitalized.

## How To Fix It

Use [Move Statements to
Callers](https://refactoring.com/catalog/moveStatementsToCallers.html)
to get the excess responsibilities out of the method that
has too many. Then remove the unused parameter(s).
