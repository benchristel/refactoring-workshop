# Idea Fragment

This smell was first identified by Katrina Owen, in her post
["What's in a Name? Anti-Patterns to a Hard
Problem"](https://www.sitepoint.com/whats-in-a-name-anti-patterns-to-a-hard-problem/).

The smell often results from breaking up a long method into
smaller ones, without regard for the coherence of the
individual pieces.

## What It Looks Like

This example is taken from [Katrina's
post](https://www.sitepoint.com/whats-in-a-name-anti-patterns-to-a-hard-problem/).
The code comes from a meetup-scheduling app.

> ```ruby
> def prev_or_next_day(date, date_type)
>  date_type == :last ? date.prev_day : date.next_day
> end
> ```
>
> [...] the method doesn’t
> isolate an entire idea. It takes a small sliver of an idea
> and sticks it in a method. When each method represents a
> fragment of a concept, the solution becomes
> incomprehensible.

## Why It Hurts

When code is broken up into small pieces that make no sense
on their own, you have a worst-of-both-worlds situation: you
still have to read all the code to make sense of what's
going on, but now you have to deal with the indirection of
method calls as well.

## How To Fix It

Use [Inline Method](../refactorings/inline-method.md) to get
all the code into one place again. Then, judiciously apply
[Extract Method](../refactorings/extract-method.md) to
factor out more coherent concepts.
