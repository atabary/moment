defmodule Moment.MomentTest do
  use ExUnit.Case, async: true

  test "year/1" do
    assert Moment.year(%Moment{year: 2000}) == 2000
  end

  test "quarter/1" do
    assert Moment.quarter(%Moment{month:  1}) == 1
    assert Moment.quarter(%Moment{month:  2}) == 1
    assert Moment.quarter(%Moment{month:  3}) == 1
    assert Moment.quarter(%Moment{month:  4}) == 2
    assert Moment.quarter(%Moment{month:  5}) == 2
    assert Moment.quarter(%Moment{month:  6}) == 2
    assert Moment.quarter(%Moment{month:  7}) == 3
    assert Moment.quarter(%Moment{month:  8}) == 3
    assert Moment.quarter(%Moment{month:  9}) == 3
    assert Moment.quarter(%Moment{month: 10}) == 4
    assert Moment.quarter(%Moment{month: 11}) == 4
    assert Moment.quarter(%Moment{month: 12}) == 4
  end

  test "month/1" do
    assert Moment.month(make_moment()) == 9
  end

  test "day/1" do
    assert Moment.day(make_moment()) == 10
  end

  test "hour/1" do
    assert Moment.hour(make_moment()) == 20
  end

  test "minute/1" do
    assert Moment.minute(make_moment()) == 36
  end

  test "second/1" do
    assert Moment.second(make_moment()) == 55
  end

  test "millisecond/1" do
    assert Moment.millisecond(make_moment()) == 566
  end

  test "microsecond/1" do
    assert Moment.microsecond(make_moment()) == 245
  end

  test "nanosecond/1" do
    assert Moment.nanosecond(make_moment()) == 37
  end

  test "to_iso_string/1" do
    assert Moment.to_iso_string(make_moment()) == "2014-09-10T20:36:55.566+09:00"
    assert Moment.to_iso_string(make_utc_moment()) == "2014-09-10T11:36:55.566+00:00"
  end

  defp make_moment() do
    %Moment{year: 2014, month: 9, day: 10, hour: 20, minute: 36, second: 55, nanosecond: 566245037, offset: 540}
  end

  defp make_utc_moment() do
    %Moment{year: 2014, month: 9, day: 10, hour: 11, minute: 36, second: 55, nanosecond: 566245037, offset: 0}
  end
end
