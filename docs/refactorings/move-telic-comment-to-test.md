# Move Telic Comment To Test

"Telic" means "relating to goals or purpose". A *Telic
Comment* is a comment that expresses why a particular bit of
code was written.

## Example

### Before

```ruby
def path_components
  # Support windows paths; customer X has servers running
  # Windows for application Y.
  if path.include? "\\"
    path.split("\\")
  else
    path.split("/")
  end
end
```

### After

```ruby
def path_components
  if path.include? "\\"
    path.split("\\")
  else
    path.split("/")
  end
end

# ...

describe "path_components" do
  it "handles windows paths" do
    # Important because customer X has servers running Windows for application Y.
    expect(path_components("\\foo\\bar\\baz.txt")).to eq ["foo", "bar", "baz.txt"]
  end

  it "handles unix paths" do
    expect(path_components("/foo/bar/baz.txt")).to eq ["foo", "bar", "baz.txt"]
  end
end
```
