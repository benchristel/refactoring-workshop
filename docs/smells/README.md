# A Partial List of Code Smells

Smells and refactorings annotated with `[BC]` are my (Ben
Christel's) original research. In other words, don't expect
to find much if you Google them. I've included them here
because I think they're relevant for fixing the types of
problems represented in `autoclop.rb`. Other smells are
drawn from the C2 Wiki and elsewhere; it's hard to determine
whom to credit.

Unless otherwise noted, all refactorings are from Martin
Fowler's book, _Refactoring: Improving the Design of Existing Code_.

## Comments

- [**Explanatory Comment.**](explanatory-comment.md) Fix using [Extract Method](../refactorings/extract-method.md) or [Remove Comment [BC]](../refactorings/remove-comment.md).
- [**Commented-out Code.**](commented-out-code.md) Fix using [Remove Comment [BC]](../refactorings/remove-comment.md).
- [**Telic Comment in Code.**](telic-comment-in-code.md) Fix using [Move Telic Comment To Test
  [BC]](../refactorings/move-telic-comment-to-test.md).
- [**Doc Comment.**](doc-comment.md) Fix using [Remove Comment [BC]](../refactorings/remove-comment.md).

## Spacing

- [**Inconsistent Formatting.**](inconsistent-formatting.md) Fix using [Rearrange
  Whitespace [BC]](../refactorings/rearrange-whitespace.md).
- [**Missing Editing Affordance [BC].**](missing-editing-affordance.md) Often fixed by [Rearrange Whitespace [BC]](../refactorings/rearrange-whitespace.md).

## Interfaces

- [**Unclear Name.**](unclear-name.md) Fix using [Rename
  Variable](../refactorings/rename-variable.md),
  [Rename Method](../refactorings/rename-method.md).
- [**Idea Fragment [Katrina Owen].**](idea-fragment.md) Fix using [Inline Method](../refactorings/inline-method.md).
- [**Data Clump.**](data-clump.md) Fix using [Preserve Whole Object](../refactorings/preserve-whole-object.md) or [Introduce Parameter Object](../refactorings/introduce-parameter-object.md).
- [**Alternative Classes with Different Interfaces.**](https://blog.codinghorror.com/code-smells/) Fix using [Rename Method](../refactorings/rename-method.md).

## Procedural Code

- [**Dead Code.**](dead-code.md) Fix using [Remove Dead Code](../refactorings/remove-dead-code.md).
- [**Long Method.**](long-method.md) Fix with [Replace Inline Code with Function Call](../refactorings/replace-inline-code-with-function-call.md) or [Extract Method](../refactorings/extract-method.md).
- [**Nested Loops and Conditionals.**](nested-loops-and-conditionals.md) Fix with [Replace Inline Code with Function Call](../refactorings/replace-inline-code-with-function-call.md), [Replace Loop with Pipeline](../refactorings/replace-loop-with-pipeline.md), or [Extract Method](../refactorings/extract-method.md).
- [**Global State**](global-state.md). Fix using [Inject Global State [BC]](../refactorings/inject-global-state.md). If code is writing to global state, use [Return Modified Value](../refactorings/return-modified-value.md).
- [**Casual Mutation [BC].**](casual-mutation.md) In straight-line code, fix with [Split Variable](../refactorings/split-variable.md). In looping code, use [Replace Loop with Pipeline](../refactorings/replace-loop-with-pipeline.md).
- [**Asymmetrical Code.**](asymmetrical-code.md) Fix with [Extract Method](../refactorings/extract-method.md), [Inline Method](../refactorings/inline-method.md), or [Rename Method](../refactorings/rename-method.md).
- [**Duplicated Code.**](duplicated-code.md) Fix by applying the [Flocking Rules [Sandi Metz and Katrina Owen]](../refactorings/flocking-rules.md).

## Objects and Messages

- [**Null Check**](null-check.md). Fix with [Introduce Null Object](../refactorings/introduce-null-object.md) or [Introduce Continuation [BC]](../refactorings/introduce-continuation.md).
- [**Feature Envy.**](feature-envy.md) Fix with [Move Method](../refactorings/move-method.md), possibly preceded by [Extract Method](../refactorings/extract-method.md).
- [**Primitive Obsession.**](primitive-obsession.md) Fix using [Replace Primitive with Object](../refactorings/replace-primitive-with-object.md). See also [Avoid Hashy Syntax In Ruby](http://wiki.c2.com/?AvoidHashySyntaxInRuby) for a language-specific refactoring technique.
- [**Switch on Type.**](switch-on-type.md) Fix using [Replace Conditional with Polymorphism](../refactorings/replace-conditional-with-polymorphism.md).
- [**Middleman.**](middleman.md) Fix using [Inline Method](../refactorings/inline-method.md).
- [**Deep Hierarchy [BC].**]() Flatten deep call trees using [Inline Method](https://refactoring.com/catalog/inlineFunction.html) and [Inline Class](https://refactoring.com/catalog/inlineClass.html). Then create shallower trees using [Extract Method](../refactorings/extract-method.md).
- [**Message Chain.**]() A.K.A. "Train Wreck" or "Law of Demeter Violation". Fix using [Replace Query with Parameter](https://refactoring.com/catalog/replaceQueryWithParameter.html) or [Extract Method](../refactorings/extract-method.md) and [Move Method](https://refactoring.com/catalog/moveFunction.html).
- [**Option Parameter [BC].**](option-parameter.md) Fix with
  [Move Statements To Caller]().
