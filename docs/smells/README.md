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

These are ordered roughly from easiest to spot and fix to hardest.

- [**Comments.**]() Fix using [Move Telic Comment To Test
  [BC]](), [Extract Method](https://refactoring.com/catalog/extractFunction.html), or [Remove Comment [BC]]().
- [**Inconsistent Formatting.**]() Fix using [Rearrange
  Whitespace [BC]]().
- [**Bad Name.**]() Fix using [Rename
  Variable](https://refactoring.com/catalog/renameVariable.html),
  [Rename Method](https://refactoring.com/catalog/changeFunctionDeclaration.html).
- [**Dead Code.**]() Fix using [Remove Dead Code](https://refactoring.com/catalog/removeDeadCode.html).
- [**Long Method.**]() Fix with [Replace Inline Code with Function Call](https://refactoring.com/catalog/replaceInlineCodeWithFunctionCall.html) or [Extract Method](https://refactoring.com/catalog/extractFunction.html).
- [**Nested Loops and Conditionals.**](http://wiki.c2.com/?ArrowAntiPattern) Fix with [Replace Inline Code with Function Call](https://refactoring.com/catalog/replaceInlineCodeWithFunctionCall.html), [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html), or [Extract Method](https://refactoring.com/catalog/extractFunction.html).
- [**Global Variable Access**](http://wiki.c2.com/?GlobalVariablesAreBad). Fix using [Inject Global [BC]](). If code is setting global variables, use [Return Modified Value](https://refactoring.com/catalog/returnModifiedValue.html).
- [**Middleman.**]() Fix using [Inline Method](https://refactoring.com/catalog/inlineFunction.html).
- [**Deep Hierarchy [BC].**]() Flatten deep call trees using [Inline Method](https://refactoring.com/catalog/inlineFunction.html) and [Inline Class](https://refactoring.com/catalog/inlineClass.html). Then create shallower trees using [Extract Method](https://refactoring.com/catalog/extractFunction.html).
- [**Missing Affordance [BC].**]() Often fixed by [Rearrange Whitespace [BC]]().
- [**Data Clump.**]() Fix using [Preserve Whole Object](https://refactoring.com/catalog/preserveWholeObject.html) or [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html).
- [**Message Chain.**]() A.K.A. "Train Wreck" or "Law of Demeter Violation". Fix using [Replace Query with Parameter](https://refactoring.com/catalog/replaceQueryWithParameter.html) or [Extract Method](https://refactoring.com/catalog/extractFunction.html) and [Move Method](https://refactoring.com/catalog/moveFunction.html).
- [**Null Check**](http://wiki.c2.com/?NullConsideredHarmful). Fix with [Introduce Null Object](https://refactoring.com/catalog/introduceSpecialCase.html) or [Introduce Continuation [BC]]().
- [**Casual Mutation [BC].**]() In straight-line code, fix with [Split Variable](https://refactoring.com/catalog/splitVariable.html). In looping code, use [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html).
- [**Feature Envy.**](http://wiki.c2.com/?FeatureEnvySmell) Fix with [Move Method](), possibly preceded by [Extract Method]().
- [**Switch on Type.**](http://wiki.c2.com/?SwitchStatementsSmell) Fix using [Replace Conditional with Polymorphism]().
- [**Primitive Obsession.**](http://wiki.c2.com/?PrimitiveObsession) Fix using [Replace Primitive with Object](). See also [Avoid Hashy Syntax In Ruby](http://wiki.c2.com/?AvoidHashySyntaxInRuby) for a language-specific refactoring technique.
- [**Alternative Classes with Different Interfaces.**](https://blog.codinghorror.com/code-smells/). Fix using [Rename Method](https://refactoring.com/catalog/changeFunctionDeclaration.html).
- [**Duplicated Code.**]() Fix by applying the [Flocking Rules [Sandi Metz and Katrina Owen]]().
- [**Asymmetrical Code.**](http://wiki.c2.com/?AsymmetricalCode) TODO: how to fix? Perhaps the smell isn't specific enough.
- [**Multiple Responsibilities.**](http://wiki.c2.com/?OneResponsibilityRule) See also [God Class](http://wiki.c2.com/?GodClass). TODO: how to fix?
