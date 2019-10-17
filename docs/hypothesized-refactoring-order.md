# A Hypothesis About The Order of Refactorings

While playing around with the autoclop exercise, I noticed
that I was prioritizing certain refactorings and delaying
others. I got the code into a very "clean" symmetrical
state, albeit one with many remaining code smells, without
introducing any new classes.

During another runthrough of the exercise, when I was
working more absentmindedly, I jumped at the opportunity to
refactor to objects, and later discovered that there was
lingering asymmetry in the code that my objects made it hard
to remove.

This made me wonder if there's a preferred order in which to
chase code smells and refactorings. My rough attempt at
outlining this order is below.

1. Whitespace
1. Dead Code / Comments
1. Names
1. Global Data and Methods
1. Deep Hierarchy / Idea Fragments
1. Asymmetry / Null Checks
1. Duplication
1. Middlemen

All of the above steps should be done without extracting
any new classes. Once the code is as clean as you can get it
using a procedural style, address the following smells:

1. Data Clumps
1. Feature Envy (and fix Primitive Obsession where it
   prevents you from fixing Feature Envy).
1. Casual Mutation
1. Switch on Type

I think this order only applies to messy procedural code.
Messy OO code likely requires a different approach.
