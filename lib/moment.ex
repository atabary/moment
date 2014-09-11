defmodule Moment do
  defstruct year: 2014, month: 0, day: 0,
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
  quarter, in 1..4
  """
  def quarter(moment) do
    div(moment.month - 1, 3) + 1
  end

  @doc """
  month, in 1..12
  """
  def month(moment) do
    moment.month
  end

  @doc """
  day, in 1..31
  """
  def day(moment) do
    moment.day
  end

  @doc """
  hour, in 0..23
  """
  def hour(moment) do
    moment.hour
  end

  @doc """
  minute, in 0..59
  """
  def minute(moment) do
    moment.minute
  end

  @doc """
  second, in 0..59
  """
  def second(moment) do
    moment.second
  end

  @doc """
  millisecond, in 0..999
  """
  def millisecond(moment) do
    div(moment.nanosecond, 1_000_000)
  end

  @doc """
  microsecond, in 0..999
  """
  def microsecond(moment) do
    rem(div(moment.nanosecond, 1_000), 1000)
  end

  @doc """
  nanosecond, in 0..999
  """
  def nanosecond(moment) do
    rem(moment.nanosecond, 1000)
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
  def format(moment, format_str) do
    Moment.Formatter.format(moment, format_str)
  end

  def build_regex!(format_str) do
    Regex.compile!(build_regex(format_str, ""))
  end

  def build_regex(format_str) do
    Regex.compile(build_regex(format_str, ""))
  end


  # Private
  # -------

  defp build_regex("YYYY" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<YYYY>\d{4})")
  end

  defp build_regex("YY" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<YY>\d{2})")
  end

  defp build_regex("MM" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<MM>\d{2})")
  end

  defp build_regex("M" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<M>\d{1,2})")
  end

  defp build_regex("DD" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<DD>\d{2})")
  end

  defp build_regex("D" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<D>\d{1,2})")
  end

  defp build_regex("HH" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<HH>\d{2})")
  end

  defp build_regex("H" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<H>\d{1,2})")
  end

  defp build_regex("mm" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<mm>\d{2})")
  end

  defp build_regex("m" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<m>\d{1,2})")
  end

  defp build_regex("ss" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<ss>\d{2})")
  end

  defp build_regex("s" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<s>\d{1,2})")
  end

  defp build_regex("SSSSSSSSS" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<SSSSSSSSS>\d{9})")
  end

  defp build_regex("SSSSSS" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<SSSSSS>\d{6})")
  end

  defp build_regex("SSS" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<SSS>\d{3})")
  end

  defp build_regex("SS" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<SS>\d{2})")
  end

  defp build_regex("S" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<S>\d{1})")
  end

  defp build_regex("ZZ" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<ZZ>[+-]\d{4})")
  end

  defp build_regex("Z" <> rest, regex_str) do
    build_regex(rest, regex_str <> ~S"(?<Z>[+-]\d{2}\:\d{2})")
  end

  defp build_regex(<< h, rest :: binary >>, regex_str) do
    build_regex(rest, regex_str <> "\\" <> <<h>>)
  end

  defp build_regex("", regex_str) do
    regex_str
  end

  defp calc_offset(now) do
    local = now
    |> :calendar.now_to_local_time
    |> :calendar.datetime_to_gregorian_seconds

    universal = now
    |> :calendar.now_to_universal_time
    |> :calendar.datetime_to_gregorian_seconds

    div(local, 60) - div(universal, 60)
  end
end
