# The Case of the CBiscuit Compiler Configurator

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

## The Kata

This kata is not about implementing new functionality;
rather, it's about safely refactoring existing code (that
is, changing design without changing behavior).

I recommend the following:

1. Wrap the existing code in tests. There are some tests
   already, but they are not comprehensive. You can manually
   "mutation test" (i.e. change or comment out some code to
   see if a test fails) to figure out whether behavior is
   covered by a test.
2. Identify one smell in the code that seems particularly
   bad to you. A partial list of code smells is provided
   below.
3. Refactor incrementally to remove *just that one smell*,
   running the tests at each step. If you feel the need to
   extract code to a new class or function, you can try:
   - TDDing the new code and then wiring it up to the
     existing code; OR
   - Relying on the existing tests to cover your refactoring
     as you extract the new class/function.
4. When the smell is gone, go to step 2.

Throughout the process, be aware of how you feel while
working on this code. What makes you feel frustrated, angry,
or stressed out? Is there anything in this code that makes
you feel happy, joyful, or at ease?

You may discover, while removing a smell A, that some other
smell B is in your way, making your refactoring harder. If
you encounter that situation, stash your changes, make a
note of A so you remember to come back to it, and fix smell
B. You may have to do this recursively several times before
you find a smell you can remove easily.

## Code Smells

- Feature Envy
- Switch on Type
- Casual Mutation
- Primitive Obsession
- Deep Hierarchy
- Global Variables
- Null Check
- Nested Control Flow Statements
- Imbalanced Abstractions
- Multiple Responsibilities
- Duplicated Code
- Dead Code

## Test Smells

- Extensive Setup
- Long Test Names
- Nested `context`s
- Multiple Assertions Per Test
- Noisy Output

## Meta-meditation

How much simpler does `autoclop` make the process of
configuring `clop`? If it were up to you, what might you
change about the functionality of `autoclop`?
