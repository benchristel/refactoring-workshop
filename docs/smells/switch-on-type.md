# Switch on Type

## What It Looks Like

```ruby
case url.scheme
when "http", "https"
  download_http!(url)
when "ftp"
  download_ftp!(url)
when "ssh"
  git_clone_ssh!(url)
else
  raise UnsupportedDownloadProtocol.new
end
```

## Why It Hurts

Switching on the type of an object, or the data it contains,
is a missed opportunity to send a message to an object and
trust it to play its role. Switch statements lead to
[Duplicated Code](duplicated-code.md) when multiple methods
use the same logic to determine what something's "type" is.

## How To Fix It

[Replace Conditional With
Polymorphism](../refactorings/replace-conditional-with-polymorphism.md)
