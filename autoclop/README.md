# Following Code Smells

## Goal

The goal of this kata is to practice removing code smells
via small, targeted refactorings, using frequent test runs
as a safety rail. The emphasis is on the practice of
refactoring, i.e. **safely and incrementally changing the
design of code without changing its observable behavior**.

## Philosophy

See [Why Incremental Refactoring?](docs/why-incremental-refactoring.md)

## Facilitator Guide

### Resources

- Use these slides TODO: LINK
- Handout: glossary of smells/refactorings/patterns (LINK?)

### Procedure

- Show slides 1-N
   - Anti-goals: we want a picture of where are going before we start
- Last slide contains an image of the IDE with the code
- Ask, "Please write down as many specific structural problems with this code as you can in N minutes, in the Zoom chat. We'll discuss them as a group when everyone is done. Don't worry about translating them into code smells; we'll do that as a group."
- Open the file with the prepared TODO comments in the IDE. Monitor the Zoom chat window. If anyone identifies a problem that isn't already annotated, add it as a comment.
- Remind people when time is almost up. "You have one minute" "finish the thought you're on". If you miss one or two issues in the Zoom chat, that's okay.
- Share your IDE. "I'm going to pick the smallest problem; one that we can fix right now."
- "For the purposes of this exercise, I trust that the tests are complete and will fail if I make a mistake."
- For loop (for each comment; break when there's X minutes left)
   - Match the problem to a code smell. Show the slide for that smell.
   - Refactor the smell away.
   - Show the slide with caveats for that smell. Explain when you wouldn't want to refactor the smell away.
- Show a finished product
- Show the final slides
- Discussion
   - Do you have a favorite pattern not discussed today?
   - How can your team use this? any obstacles?


## Scenario

Your company uses a language called CBiscuit for a lot of
its internal work. The CBiscuit compiler, called `clop`, is
very complex and has a lot of configuration options. To
enable developers to compile code in a consistent way, your
team has developed a tool, `autoclop`, to automatically
configure `clop`.

Unfortunately, `autoclop` has grown chaotically over the
months your team has been maintaining it, with no consistent
architecture or design strategy. New features are becoming
harder and harder to add. Can you clean up the code smells?

## Warm-up

Run the following in this directory to set up the project
(assuming you have a recent version of Ruby installed):

```
bundle install
```

Then, to run the tests:

```
bundle exec rspec spec
```

## Active Reading

1. Skim through `autoclop.rb`, aiming to answer the following
   questions:
   - What does the code do, in general terms?
   - What is the interface to this code? What are the
     inputs, outputs, and public methods?
   - Which methods looks like they are intended to be
     private?
   - What concepts does the code know about?
2. Draw a directed graph representing the call graph of the
   methods. That is, if method A directly calls method
   B, draw this:

   ```
   A --> B
   ```

   What do you notice about the shape of the call graph?
3. Which methods are application-specific and which are
   application-agnostic (i.e. general-purpose utilities)?
4. Which methods directly or indirectly make system calls?
   Actions that involve system calls include reading and
   writing files, forking processes, getting the current
   time, talking to other computers on the network, and
   generating random numbers.
5. Look back at your call graph drawing. What is the length
   of the longest path between a public method and a
   system call?
5. Which methods directly or indirectly depend on global
   state?
6. Which methods modify global state?
7. Which methods are are *pure functions*? A pure function
   is one whose only inputs are its arguments and whose only
   output is its return value.

## The Kata

I recommend the following process:

1. Identify one smell in the code that seems particularly
   bad to you. A partial list of code smells is provided
   below.
2. Refactor incrementally to remove *just that one smell*,
   running the tests at each step. If you feel the need to
   extract code to a new class or function, you can try:
   - TDDing the new code and then wiring it up to the
     existing code; OR
   - Relying on the existing tests to cover your refactoring
     as you extract the new class/function.
3. When the smell is gone, repeat from step 1.

Throughout the process, be aware of how you feel while
working on this code. What makes you feel frustrated, angry,
or stressed out? Is there anything in this code that makes
you feel happy, joyful, or at ease?

You might discover, while removing a smell A, that some other
smell B is in your way, making your refactoring harder. If
you encounter that situation, stash your changes, make a
note of A so you remember to come back to it, and fix smell
B. You might have to do this recursively several times before
you find a smell you can remove easily.

## Code Smells

- [Feature Envy](http://wiki.c2.com/?FeatureEnvySmell)
- [Switch on Type](http://wiki.c2.com/?SwitchStatementsSmell)
- Casual Mutation
- [Primitive Obsession](http://wiki.c2.com/?PrimitiveObsession). See also [Avoid Hashy Syntax In Ruby](http://wiki.c2.com/?AvoidHashySyntaxInRuby) for a language-specific refactoring technique.
- Deep Hierarchy
- [Global Variables](http://wiki.c2.com/?GlobalVariablesAreBad)
- [Null Check](http://wiki.c2.com/?NullConsideredHarmful)
- [Nested Loops and Conditionals](http://wiki.c2.com/?ArrowAntiPattern)
- [Asymmetrical Code](http://wiki.c2.com/?AsymmetricalCode)
- [Multiple Responsibilities](http://wiki.c2.com/?OneResponsibilityRule). See also [God Class](http://wiki.c2.com/?GodClass).
- Duplicated Code
- Dead Code
- Inconsistent Formatting
- Run-on Code
