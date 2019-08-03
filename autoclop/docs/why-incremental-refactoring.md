# Why Incremental Refactoring?

> *When I began working in this style, I had to give up the idea that I had the perfect vision of the system [...]. Instead, I had to accept that **I was only the vehicle for the system expressing its own desire for simplicity**. My vision could shape initial direction, and my attention to the desires of the code could affect how quickly and how well the system found its desired shape, but the system is riding me much more than I am riding the system.*
>
> —[Kent Beck](http://wiki.c2.com/?OnceAndOnlyOnce)

The incremental nature of the refactoring process is of
vital importance, but it's difficult to learn. Incremental
refactoring takes a lot of discipline and focus. Hence
this kata, which provides a safe place to practice the
discipline.

Incremental refactoring can seem unbearably slow at first.
When I see messy code, I often feel it would be fastest and
easiest to rip it out and start over from scratch.

I resist that urge because I know it's risky. There's a
good chance I haven't understood the existing code, and the
replacement I envision might not end up being much better.
Also, I might not have time to finish the rewrite, in which
case all my work will go to waste.

I used to be afraid that if I refactored incrementally, the
code wouldn't turn out the way I wanted, unless I had a
design in mind from the start. It's natural to visualize
refactoring as a maze of possible paths. Each decision, each
change point, is a branch in the maze. How do you know you
aren't going to run into a dead end?

Having explored many refactoring mazes, I can tell you that
there *are* dead ends, but thankfully, the vast majority of
them are quite short and don't require a lot of
backtracking—*if* you take small steps and focus each change
on removing one specific problem from the code. You only
need to backtrack when you make a big upfront commitment to
a particular design—and then that design turns out not to be
a good one.

To reinforce the idea of incremental improvement, I like to
use the metaphor of "code weeds" instead of "code smells".
If the codebase is a garden, a *code weed* is an antipattern
that makes the garden less healthy and less productive. In
this analogy, a rewrite of the code is like plowing a
whole, weed-ridden garden into the ground and starting over.
Perhaps that's refreshing, but it's certainly expensive.
Also, if you use the same gardening practices for the second
garden that you used for the first, guess what you end up
with? Another garden full of weeds.

A code weed is a pattern in the code that is identifiably
harmful, nameable, and graspable; it can be uprooted without
disturbing its surroundings too much.
