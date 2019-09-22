# Asymmetrical Code

Code accomplishes analogous tasks in different ways, at
different times, in different orders, or at different levels
of abstraction.

## What It Looks Like

```ruby
if https_url?(url) || url.start_with?("ftp://")
  Downloader.get(url)
elsif git_ssh_url?(url)
  Git.clone(url)
end
```

Here, we are detecting the protocol specified by a URL
string using two different levels of abstraction. For https
and git, we call a specialized method, but to detect an FTP
URL, we parse the string directly.

Additionally, we are fetching the resource in asymmetrical
ways. HTTPS and FTP are combined into a single
`Downloader.get` method (which probably ends up parsing the
URL again to figure out which protocol to use), while Git
resources use a totally separate interface.

A more symmetrical implementation of the logic above might
look like this:

```ruby
downloader =
  if https_url?(url)
    HttpsDownloader
  elsif ftp_url?(url)
    FtpDownloader
  elsif git_url?(url)
    GitDownloader
  else
    raise ArgumentError.new("Unsupported protocol in URL: '#{url}'")
  end
downloader.download(url)
```

## Why It Hurts

Asymmetrical code obscures similarities. By making things
that are essentially similar appear different, we cast doubt
on whether they are truly similar. For example: is there a
reason there's no `ftp_url?` method in the code above?
Someone reading the code might spend time figuring it out,
only to realize in the end that there is no reason, except
an accident of history.

When we obscure similarity, we also obscure important
differences. When similar things appear different, the
things that are truly different don't stand out. Special
cases don't look any more special than the "regular" cases.
This makes it harder to tell when we can safely follow
common patterns in the code and when we have to take
special care to handle an edge case.

## How To Fix It

Balance abstractions using [Extract Method](../refactorings/extract-method.md), or perhaps
[Inline Method](../refactorings/inline-method.md). Bring
divergent interfaces into alignment with [Rename
Method](../refactorings/rename-method.md).

## References

- [Asymmetrical Code on C2Wiki](http://wiki.c2.com/?AsymmetricalCode)
