defmodule Moment.ParserTest do
  use ExUnit.Case, async: true

  test "parse/3 (date)" do
    m = %Moment{year: 2014, month: 1, day: 1, hour: 14, minute: 32, second: 55, nanosecond: 565175000, offset: 540}

    expected = %Moment{year: 2012, month: 12, day: 11, offset: 540}
    assert Moment.Parser.parse!("2012/12/11", "YYYY/MM/DD", m) == expected

    expected = %Moment{year: 2012, month: 12, day: 11, offset: 540}
    assert Moment.Parser.parse!("12/12/11", "YY/M/D", m) == expected

    expected = %Moment{year: 2012, month:  9, day:  3, offset: 540}
    assert Moment.Parser.parse!("2012/09/03", "YYYY/MM/DD", m) == expected

    expected = %Moment{year: 2012, month:  9, day:  3, offset: 540}
    assert Moment.Parser.parse!("12/9/3", "YY/M/D", m) == expected

    expected = %Moment{year: 1972, month:  1, day:  1, offset: 540}
    assert Moment.Parser.parse!("72", "YY", m) == expected
  end

  test "parse/3 (time)" do
    m = %Moment{year: 2014, month: 9, day: 11, hour: 14, minute: 32, second: 55, nanosecond: 565175000, offset: 540}

    expected = %Moment{year: 2014, month: 9, day: 11, hour: 14, minute: 32, second: 55, nanosecond: 0, offset: 540}
    assert Moment.Parser.parse!("14:32:55", "HH:mm:ss", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, hour:  9, minute:  5, second:  7, nanosecond: 0, offset: 540}
    assert Moment.Parser.parse!("09:05:07", "HH:mm:ss", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, hour: 14, minute: 32, second: 55, nanosecond: 0, offset: 540}
    assert Moment.Parser.parse!("14:32:55", "H:m:s", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, hour:  9, minute:  5, second:  7, nanosecond: 0, offset: 540}
    assert Moment.Parser.parse!("9:5:7", "H:m:s", m) == expected
  end

  test "parse/3 (nanoseconds)" do
    m = %Moment{year: 2014, month: 9, day: 11, hour: 14, minute: 32, second: 55, nanosecond: 565175000, offset: 540}

    expected = %Moment{year: 2014, month: 9, day: 11, nanosecond: 123456789, offset: 540}
    assert Moment.Parser.parse!("123456789", "SSSSSSSSS", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, nanosecond: 123456000, offset: 540}
    assert Moment.Parser.parse!("123456", "SSSSSS", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, nanosecond: 123000000, offset: 540}
    assert Moment.Parser.parse!("123", "SSS", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, nanosecond: 120000000, offset: 540}
    assert Moment.Parser.parse!("12", "SS", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, nanosecond: 100000000, offset: 540}
    assert Moment.Parser.parse!("1", "S", m) == expected
  end

  test "parse/3 (offset)" do
    m = %Moment{year: 2014, month: 9, day: 11, hour: 14, minute: 32, second: 55, nanosecond: 565175000, offset: 540}

    expected = %Moment{year: 2014, month: 9, day: 11, offset:  510}
    assert Moment.Parser.parse!("+08:30", "Z", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, offset: -510}
    assert Moment.Parser.parse!("-08:30", "Z", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, offset:  510}
    assert Moment.Parser.parse!("+0830", "ZZ", m) == expected

    expected = %Moment{year: 2014, month: 9, day: 11, offset: -510}
    assert Moment.Parser.parse!("-0830", "ZZ", m) == expected
  end
end
