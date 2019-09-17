# Doc Comment

## What It Looks Like

```ruby
# send_message() sends a Slack message.
# parameters:
# * recipient (string) the username or channel to receive the message.
#       Must start with @ or #.
# * text (string) the body of the message
# * attachment (Attachment) an Attachment object
#       representing the attachment to send with the message.
# returns:
#   nothing
# raises:
#   RuntimeError if delivering the message failed.
def send_message(recipient, text, attachment)
  # ...
end
```

## Why It Hurts

Doc comments are very often just unhelpful clutter. Keeping
them in sync with the code is a lot of tedious work, and
when it's not done properly, the comments become misleading.

You can get more bang for your buck by using unit tests to
demonstrate how a module is intended to be used.

## How To Fix It

Use [Remove Comment](../refactorings/remove-comment.md).

## Caveats

Doc comments can be leveraged to explain higher-level
architectural principles or performance characteristics that
unit tests don't reveal. If you're in a situation where
that's valuable, perhaps you can draw inspiration from the
[literate programming](https://en.wikipedia.org/wiki/Literate_programming)
approach pioneered by Donald Knuth.
