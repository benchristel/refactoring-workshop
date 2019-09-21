# Replace Inline Code With Function Call

Replace a chunk of code with a call to a method that does
the same thing. Often, you can find a standard library
function that does what you need.

This is one of the most valuable refactorings, because it
makes code more expressive and readable *and* reduces the
total amount of code in the codebase!

## Example

### Before

```ruby
names_string = ""
names.each_with_index do |name, index|
  names_string << name
  if index < names.length - 1
    names_string << ", "
  end
end
```

### After

```ruby
names_string = names.join(", ")
```

## References

- [Replace Inline Code With Function Call on Refactoring.com](https://refactoring.com/catalog/replaceInlineCodeWithFunctionCall.html)
