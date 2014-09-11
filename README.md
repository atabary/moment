# Moment

Moment is designed to bring easy date and time handling to Elixir. Its semantic (notably for formatting/parsing) is inspired by [Moment.js](http://momentjs.com/).

## Examples

```elixir
iex(1)> Moment.now()
%Moment{day: 11, hour: 15, minute: 8, month: 9, nanosecond: 228523000,
 offset: 540, second: 13, year: 2014}

iex(2)> Moment.utcnow()
%Moment{day: 11, hour: 6, minute: 8, month: 9, nanosecond: 84602000, offset: 0,
 second: 17, year: 2014}

iex(3)> Moment.format(Moment.now(), "YYYY/MM/DD HH:mm")
"2014/09/11 15:08"

iex(4)> Moment.parse!("2014/09/11 15:08", "YYYY/MM/DD HH:mm")
%Moment{day: 11, hour: 15, minute: 8, month: 9, nanosecond: 0, offset: 540,
 second: 0, year: 2014}
```
