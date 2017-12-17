# Kkmserver API

A Ruby wrapper for the [Kkmserver API](https://kkmserver.ru/KkmServer#Primer).

## Using
#### Getting the list of devices on the server
```ruby
Kkmserver.list
```

#### Getting info about cash register
```ruby
register = Kkmserver.list.last
register.state
```

#### Open/close shift
```ruby
register.open_shift
register.close_shift
```

#### Print x-report/z-report
```ruby
register.x_report
register.z_report
```

#### Depositing/withdrawal money
```ruby
register.depositing_cash(5000)
register.payment_cash(5000)
```

#### Open cash drawer
```ruby
register.open_cash_drawer
```

#### Get line length of register
```ruby
register.line_length
```

#### Print check
```ruby
register = Kkmserver.list.last

register.open_shift
row = Kkmserver::CheckRow.new(
  text: 'Кроссовки Nike',
  register_name: 'Кроссовки Nike RN6',
  quantity: 1,
  price: 2497.45,
  ean13: '1234567890123'
)
result = register.print_check(type: 0, electronic: 2497.45, rows: [row.to_h])
```
