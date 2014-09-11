defmodule Moment.FormatterTest do
  use ExUnit.Case, async: true

  test "format/2" do
    m = %Moment{year: 2014, month: 10, day: 10, hour: 20, minute: 36, second: 55, nanosecond: 566245037, offset: 540}
    assert Moment.format(m,      "YYYY") ==      "2014"
    assert Moment.format(m,        "YY") ==        "14"
    assert Moment.format(m,         "Q") ==         "4"
    assert Moment.format(m,        "MM") ==        "10"
    assert Moment.format(m,         "M") ==        "10"
    assert Moment.format(m,        "DD") ==        "10"
    assert Moment.format(m,         "D") ==        "10"
    assert Moment.format(m,        "HH") ==        "20"
    assert Moment.format(m,         "H") ==        "20"
    assert Moment.format(m,        "mm") ==        "36"
    assert Moment.format(m,         "m") ==        "36"
    assert Moment.format(m,        "ss") ==        "55"
    assert Moment.format(m,         "s") ==        "55"
    assert Moment.format(m, "SSSSSSSSS") == "566245037"
    assert Moment.format(m,    "SSSSSS") ==    "566245"
    assert Moment.format(m,       "SSS") ==       "566"
    assert Moment.format(m,        "SS") ==        "56"
    assert Moment.format(m,         "S") ==         "5"
    assert Moment.format(m,        "ZZ") ==     "+0900"
    assert Moment.format(m,         "Z") ==    "+09:00"
  end

  test "format/2 (short)" do
    m = %Moment{year: 2014, month: 9, day: 2, hour: 9, minute: 3, second: 5, nanosecond: 566245037, offset: 540}
    assert Moment.format(m, "M") == "9"
    assert Moment.format(m, "D") == "2"
    assert Moment.format(m, "H") == "9"
    assert Moment.format(m, "m") == "3"
    assert Moment.format(m, "s") == "5"
  end
end
