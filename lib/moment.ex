defmodule Moment do
  defstruct year: 2014, month: 9, day: 8,
            hour: 0, minute: 0, second: 0,
            nanosecond: 0, offset: 0

  @doc """
  Returns an instance of Moment in Universal Time.
  """
  def utcnow() do
    now = :os.timestamp

    {{ year, month, day }, { hour, minute, second }} = :calendar.now_to_universal_time(now)
    { _megasecond, _second, microsecond } = now

    %Moment{year: year, month: month, day: day,
            hour: hour, minute: minute, second: second,
            nanosecond: microsecond * 1000, offset: 0}
  end

  @doc """
  Returns an instance of Moment in local time.
  """
  def now() do
    now = :os.timestamp

    {{ year, month, day }, { hour, minute, second }} = :calendar.now_to_local_time(now)
    { _megasecond, _second, microsecond } = now

    offset = calc_offset(now)

    %Moment{year: year, month: month, day: day,
            hour: hour, minute: minute, second: second,
            nanosecond: microsecond * 1000, offset: offset}
  end


  # Accessors
  # ---------

  @doc """
  year
  """
  def year(moment) do
    moment.year
  end

  @doc """
  quarter, in [1; 4]
  """
  def quarter(moment) do
    div(moment.month - 1, 3) + 1
  end

  @doc """
  month, in [1; 12]
  """
  def month(moment) do
    moment.month
  end

  @doc """
  day, in [1; 31]
  """
  def day(moment) do
    moment.day
  end

  @doc """
  hour, in [0; 23]
  """
  def hour(moment) do
    moment.hour
  end

  @doc """
  minute, in [0; 59]
  """
  def minute(moment) do
    moment.minute
  end

  @doc """
  second, in [0; 59]
  """
  def second(moment) do
    moment.second
  end

  @doc """
  millisecond, in [0; 1000[
  """
  def millisecond(moment) do
    div(moment.nanosecond, 1_000_000)
  end

  @doc """
  microsecond, in [0; 1,000,000[
  """
  def microsecond(moment) do
    div(moment.nanosecond, 1_000)
  end

  @doc """
  nanosecond, in [0; 1,000,000,000[
  """
  def nanosecond(moment) do
    moment.nanosecond
  end


  # Formatting
  # ----------

  @doc """
  Format moment as an ISO8601 string.
  """
  def to_iso_string(moment) do
    format(moment, "YYYY-MM-DDTHH:mm:ss.SSSZ")
  end

  @doc """
  Format moment according to format string.
  """
  def format(moment, "YYYY" <> rest), do: Integer.to_string(moment.year)          <> format(moment, rest)
  def format(moment,   "YY" <> rest), do: format_digits(rem(moment.year, 100), 2) <> format(moment, rest)
  def format(moment,    "Q" <> rest), do: Integer.to_string(quarter(moment))      <> format(moment, rest)
  def format(moment,   "MM" <> rest), do: format_digits(moment.month, 2)          <> format(moment, rest)
  def format(moment,    "M" <> rest), do: Integer.to_string(moment.month)         <> format(moment, rest)
  def format(moment,   "DD" <> rest), do: format_digits(moment.day, 2)            <> format(moment, rest)
  def format(moment,    "D" <> rest), do: Integer.to_string(moment.day)           <> format(moment, rest)
  def format(moment,   "HH" <> rest), do: format_digits(moment.hour, 2)           <> format(moment, rest)
  def format(moment,    "H" <> rest), do: Integer.to_string(moment.hour)          <> format(moment, rest)
  def format(moment,   "mm" <> rest), do: format_digits(moment.minute, 2)         <> format(moment, rest)
  def format(moment,    "m" <> rest), do: Integer.to_string(moment.minute)        <> format(moment, rest)
  def format(moment,   "ss" <> rest), do: format_digits(moment.second, 2)         <> format(moment, rest)
  def format(moment,    "s" <> rest), do: Integer.to_string(moment.second)        <> format(moment, rest)

  def format(moment, "SSSSSSSSS" <> rest) do
    format_digits(moment.nanosecond, 9) <> format(moment, rest)
  end

  def format(moment, "SSSSSS" <> rest) do
    format_digits(div(moment.nanosecond, 1_000), 6) <> format(moment, rest)
  end

  def format(moment, "SSS" <> rest) do
    format_digits(div(moment.nanosecond, 1_000_000), 3) <> format(moment, rest)
  end

  def format(moment, "SS" <> rest) do
    format_digits(div(moment.nanosecond, 10_000_000), 2) <> format(moment, rest)
  end

  def format(moment, "S" <> rest) do
    Integer.to_string(div(moment.nanosecond, 100_000_000)) <> format(moment, rest)
  end

  def format(moment, "ZZ" <> rest) do
    offset_h = format_digits(div(abs(moment.offset), 60), 2)
    offset_m = format_digits(rem(abs(moment.offset), 60), 2)
    if moment.offset >= 0 do
      "+#{offset_h}#{offset_m}" <> format(moment, rest)
    else
      "-#{offset_h}#{offset_m}" <> format(moment, rest)
    end
  end

  def format(moment, "Z" <> rest) do
    offset_h = format_digits(div(abs(moment.offset), 60), 2)
    offset_m = format_digits(rem(abs(moment.offset), 60), 2)
    if moment.offset >= 0 do
      "+#{offset_h}:#{offset_m}" <> format(moment, rest)
    else
      "-#{offset_h}:#{offset_m}" <> format(moment, rest)
    end
  end

  def format(moment, << h, rest :: binary >>) do
    << h, format(moment, rest) :: binary >>
  end

  def format(moment, "") do
    ""
  end


  # Private
  # -------

  defp calc_offset(now) do
    local = now
    |> :calendar.now_to_local_time
    |> :calendar.datetime_to_gregorian_seconds

    universal = now
    |> :calendar.now_to_universal_time
    |> :calendar.datetime_to_gregorian_seconds

    div(local, 60) - div(universal, 60)
  end

  defp format_digits(i, n \\ 2) do
    :erlang.iolist_to_binary(:io_lib.format("~.#{n}.0w", [i]))
  end
end
