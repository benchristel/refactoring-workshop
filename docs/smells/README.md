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

- [**Unclear Name.**]() Fix using [Rename
  Variable](https://refactoring.com/catalog/renameVariable.html),
  [Rename Method](https://refactoring.com/catalog/changeFunctionDeclaration.html).
- [**Idea Fragment [Katrina Owen].**](https://www.sitepoint.com/whats-in-a-name-anti-patterns-to-a-hard-problem/) Fix using [Inline Method]().
- [**Data Clump.**]() Fix using [Preserve Whole Object](https://refactoring.com/catalog/preserveWholeObject.html) or [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html).
- [**Alternative Classes with Different Interfaces.**](https://blog.codinghorror.com/code-smells/) Fix using [Rename Method](https://refactoring.com/catalog/changeFunctionDeclaration.html).

## Imperative Code

- [**Dead Code.**]() Fix using [Remove Dead Code](https://refactoring.com/catalog/removeDeadCode.html).
- [**Long Method.**]() Fix with [Replace Inline Code with Function Call](https://refactoring.com/catalog/replaceInlineCodeWithFunctionCall.html) or [Extract Method](../refactorings/extract-method.md).
- [**Nested Loops and Conditionals.**](http://wiki.c2.com/?ArrowAntiPattern) Fix with [Replace Inline Code with Function Call](https://refactoring.com/catalog/replaceInlineCodeWithFunctionCall.html), [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html), or [Extract Method](../refactorings/extract-method.md).
- [**Global Variable Access**](http://wiki.c2.com/?GlobalVariablesAreBad). Fix using [Inject Global [BC]](). If code is setting global variables, use [Return Modified Value](https://refactoring.com/catalog/returnModifiedValue.html).
- [**Casual Mutation [BC].**]() In straight-line code, fix with [Split Variable](https://refactoring.com/catalog/splitVariable.html). In looping code, use [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html).
- [**Asymmetrical Code.**](http://wiki.c2.com/?AsymmetricalCode) TODO: how to fix? Perhaps the smell isn't specific enough.
- [**Duplicated Code.**]() Fix by applying the [Flocking Rules [Sandi Metz and Katrina Owen]]().

## Objects and Messages

- [**Null Check**](http://wiki.c2.com/?NullConsideredHarmful). Fix with [Introduce Null Object](https://refactoring.com/catalog/introduceSpecialCase.html) or [Introduce Continuation [BC]]().
- [**Feature Envy.**](http://wiki.c2.com/?FeatureEnvySmell) Fix with [Move Method](), possibly preceded by [Extract Method](../refactorings/extract-method.md).
- [**Primitive Obsession.**](http://wiki.c2.com/?PrimitiveObsession) Fix using [Replace Primitive with Object](). See also [Avoid Hashy Syntax In Ruby](http://wiki.c2.com/?AvoidHashySyntaxInRuby) for a language-specific refactoring technique.
- [**Multiple Responsibilities.**](http://wiki.c2.com/?OneResponsibilityRule) See also [God Class](http://wiki.c2.com/?GodClass). TODO: how to fix?
- [**Switch on Type.**](http://wiki.c2.com/?SwitchStatementsSmell) Fix using [Replace Conditional with Polymorphism]().
- [**Middleman.**]() Fix using [Inline Method](https://refactoring.com/catalog/inlineFunction.html).
- [**Deep Hierarchy [BC].**]() Flatten deep call trees using [Inline Method](https://refactoring.com/catalog/inlineFunction.html) and [Inline Class](https://refactoring.com/catalog/inlineClass.html). Then create shallower trees using [Extract Method](../refactorings/extract-method.md).
- [**Message Chain.**]() A.K.A. "Train Wreck" or "Law of Demeter Violation". Fix using [Replace Query with Parameter](https://refactoring.com/catalog/replaceQueryWithParameter.html) or [Extract Method](../refactorings/extract-method.md) and [Move Method](https://refactoring.com/catalog/moveFunction.html).
