# Replace Conditional with Polymorphism

## Example

### Before

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

### After

```ruby
download.start!

# elsewhere ...

class DownloadFactory
  def build(url)
    the_class =
      case url.scheme
      when "http", "https"
        HttpDownload
      when "ftp"
        FtpDownload
      when "ssh"
        GitSshDownload
      else
        raise UnsupportedDownloadProtocol.new
      end
    the_class.new(url)
  end
end
```
