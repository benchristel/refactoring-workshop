# Refactoring Code Smells

This is an interactive, remote-friendly workshop that
teaches refactoring.

The overall flow of the workshop goes like this:

- (10 minutes) Facilitator gives a presentation defining
  refactoring and code smells.
- (15 minutes) Participants individually identify specific
  structural problems in a 70-line Ruby file, posting their
  observations in a chatroom.
- (2 hours) Participants mob-program to fix one problem at a
  time, with the facilitator typing code and promoting
  discussion.
- (30 minutes) The group debriefs with another presentation
  and time for questions and discussion.

## Prerequisites and Limitations

- You'll need a facilitator with strong refactoring skills.
- You'll need some way of video conferencing and collecting
  participant suggestions in a chat log. I've used Zoom for
  this.
- In theory, the workshop should scale up to many
  participants (dozens? hundreds?) but I have not tried it
  on large groups yet.
- I recommend you use IntelliJ or RubyMine as your editor.
  You'll need a paid license, or the program will quit every
  30 minutes. Other editors will work, but you'll have to
  split your screen between tests and code, and the
  automated refactoring support may not be as good.

## Goals

The goal of this workshop is to practice removing code
smells via small, targeted refactorings, using frequent test
runs as a safety rail. The emphasis is on the practice of
refactoring, i.e. **safely and incrementally changing the
design of code without changing its observable behavior**.

A breakdown of the goals:

- **Persuade** participants that...
  - refactoring is a mutually beneficial activity,
    furthering the goals of individual programmers, the
    team, the company, its customers, and the users of the
    product.
  - you don't need to have the perfect design in mind
    before starting to refactor.
  - you *do* need tests before you can refactor safely.
- Give participants time to **practice**...
  - identifying code smells.
  - focusing on one refactoring at a time.
  - incrementally improving a codebase, avoiding big-bang
    rewrites.
  - using the language of code smells to discuss design
    tradeoffs.
  - communicating the motivation for a change in Git commit
    messages.
  - making backwards-compatible changes to an interface
    (e.g. creating a class to hold formerly global methods,
    leaving the existing global methods as middlemen).
- **Demonstrate**...
  - getting fast feedback by running all the tests after
    every change.

## Anti-Goals

This workshop can't do everything—after all, we only have
three hours. Some things we're intentionally *not* going to
cover:

- **Writing tests.** The example code comes with tests,
  which are supposed to be complete. The facilitator should
  communicate to participants that he/she trusts the tests
  and will not need to add more.
- **Refactoring test code.**  If the group ends up
  looking at the test code for any reason, the facilitator
  should mention that the tests are *not exemplary*, but
  that refactoring them is out of scope. Refactoring
  tests presents its own set of pitfalls, and we'd rather
  not address them in this workshop.
- **Fixing bugs.** The participants might find bugs in the
  code, or behaviors they think should be changed. The
  facilitator should remind them that the goal of
  refactoring is to hold behavior constant while changing
  structure. By making the bugfix or feature change later,
  in a separate commit, we'll more clearly communicate our
  intent to programmers who work on this code in the future.

## Facilitator Guide

See [FACILITATING.md](FACILITATING.md)

## Definitions

- **Code Smell:** "a surface indication that usually
  corresponds to a deeper problem in the system". Source:
  [martinfowler.com](https://www.martinfowler.com/bliki/CodeSmell.html)
- **Refactoring:** (noun) "a change made to the internal
  structure of software to make it easier to understand and
  cheaper to modify without changing its observable
  behavior". Source:
  [refactoring.com](https://refactoring.com/)
- **Refactoring:** (verb) "to restructure software by
  applying a series of refactorings without changing its
  observable behavior". Source:
  [refactoring.com](https://refactoring.com/)
