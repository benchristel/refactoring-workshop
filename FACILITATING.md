# Facilitator Guide

## Resources

- Use these slides TODO: LINK
- Handout: glossary of smells/refactorings/patterns (LINK?)

## Before the Workshop

- Practice the presentation. If you like, you can read off
  the speaker notes.
- `git clone` this repository.
- Run `bundle install` to get the dependencies.
- Run `bundle exec rspec spec` to run the tests.
- Open this repository in your IDE.
- TODO: how to configure IntelliJ/RubyMine to run the tests?

## During the Workshop

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

## After the Workshop

Send participants the following list of resources referenced
by this workshop:

- Martin Fowler's site [Refactoring.com](https://refactoring.com) and its [catalog of refactorings](https://refactoring.com/catalog/)
- The [CodeSmell](http://wiki.c2.com/?CodeSmell) page on [C2Wiki](http://wiki.c2.com)
- [RefactorLowHangingFruit on C2Wiki](http://wiki.c2.com/?RefactorLowHangingFruit)
- [Refactoring.guru](https://refactoring.guru/)
- [_99 Bottles of OOP_](https://www.sandimetz.com/99bottles) by Sandi Metz and Katrina Owen.
- [SourceMaking.com's list of smells](https://sourcemaking.com/refactoring/smells)
- [The repository for the workshop](https://github.com/benchristel/refactoring-workshop)!

If you think you might facilitate the workshop again, ask
participants for feedback. What would they change about the
workshop? What did they find useful?
