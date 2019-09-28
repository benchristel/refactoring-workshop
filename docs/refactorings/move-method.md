# Move Method

## Example

### Before

```ruby
class PaymentCalculator
  def invoice_total
    @invoice.parts.map(&:price).reduce(:+) + @invoice.labor
  end

  # ...
end
```

### After

```ruby
class PaymentCalculator
  # ...
end

# ...

class Invoice
  def total
    parts.map(&:price).reduce(:+) + labor
  end

  # ...
end
```
