# Introduce Continuation

Pass a block to a method to tell it what to do in a special
case.

## Example

Here's an example of a class in the standard library that
implements the continuation-passing interface: Hash.

### Before

```ruby
def get
  hash["name"] || "anonymous"
end
```

### After

```ruby
def name
  hash.fetch("name") { "anonymous" }
end
```

## A More Motivated Example

### Before

In the code below, the caller of `git_branch` has
to know that it might return `nil`, and handle that case
appropriately. If the caller forgets to handle the nil case,
the program will have a bug.

```ruby
def git_branch
  parameters.git_branch || Git.current_branch
end
```

### After

Here, the `git_branch` method itself can check that a block
has been passed, and raise an error if not. This ensures
that the caller always passes a block to handle the case
where the parameters don't specify a git branch.

```ruby
def git_branch
  parameters.git_branch { Git.current_branch }
end
```

If the caller really wants a nil value, they have to say
that explicitly:

```ruby
def git_branch
  parameters.git_branch { nil }
end
```
