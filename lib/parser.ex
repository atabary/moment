defmodule Moment.Parser do

  def parse!(moment_str, format_str) do
    parse!(moment_str, format_str, Moment.now())
  end

  def parse!(moment_str, format_str, default) do
    case parse(moment_str, format_str, default) do
      {:ok, moment} ->
        moment
      {:error, reason} ->
        raise reason
    end
  end

  def parse(moment_str, format_str) do
    parse(moment_str, format_str, Moment.now())
  end

  def parse(moment_str, format_str, default) do
    case build_regex(format_str) do
      {:error, reason} ->
        {:error, reason}
      {:ok, regex} ->
        parse_with_regex(moment_str, regex, default)
    end
  end

  defp parse_with_regex(moment_str, regex, default) do
    case Regex.named_captures(regex, moment_str) do
      nil ->
        {:error, "regex and string do not match"}
      map ->
        {:ok, %Moment{year: get_year(map, default.year), month: get_month(map, default.month),
                      day: get_day(map, default.day), hour: get_hour(map, 0), minute: get_minute(map, 0),
                      second: get_second(map, 0), nanosecond: get_nanosecond(map, 0),
                      offset: get_offset(map, default.offset)}}
    end
  end


  # Private
  # -------

  defp build_regex!(format_str) do
    Regex.compile!(build_regex(format_str, ""))
  end

  defp build_regex(format_str) do
    Regex.compile(build_regex(format_str, ""))
  end

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


  # Map Analysis
  # ------------

  defp get_year(map, default) do
    cond do
      Dict.has_key?(map, "YYYY") ->
        {year, _} = Integer.parse(Dict.get(map, "YYYY"))
        year

      Dict.has_key?(map, "YY") ->
        {yy, _} = Integer.parse(Dict.get(map, "YY"))
        if yy >= 70, do: yy + 1900, else: yy + 2000

      true ->
        default
    end
  end

  defp get_month(map, default) do
    cond do
      Dict.has_key?(map, "MM") ->
        {month, _} = Integer.parse(Dict.get(map, "MM"))
        month

      Dict.has_key?(map, "M") ->
        {month, _} = Integer.parse(Dict.get(map, "M"))
        month

      true ->
        default
    end
  end

  defp get_day(map, default) do
    cond do
      Dict.has_key?(map, "DD") ->
        {day, _} = Integer.parse(Dict.get(map, "DD"))
        day

      Dict.has_key?(map, "D") ->
        {day, _} = Integer.parse(Dict.get(map, "D"))
        day

      true ->
        default
    end
  end

  defp get_hour(map, default) do
    cond do
      Dict.has_key?(map, "HH") ->
        {hour, _} = Integer.parse(Dict.get(map, "HH"))
        hour

      Dict.has_key?(map, "H") ->
        {hour, _} = Integer.parse(Dict.get(map, "H"))
        hour

      true ->
        default
    end
  end

  defp get_minute(map, default) do
    cond do
      Dict.has_key?(map, "mm") ->
        {minute, _} = Integer.parse(Dict.get(map, "mm"))
        minute

      Dict.has_key?(map, "m") ->
        {minute, _} = Integer.parse(Dict.get(map, "m"))
        minute

      true ->
        default
    end
  end

  defp get_second(map, default) do
    cond do
      Dict.has_key?(map, "ss") ->
        {second, _} = Integer.parse(Dict.get(map, "ss"))
        second

      Dict.has_key?(map, "s") ->
        {second, _} = Integer.parse(Dict.get(map, "s"))
        second

      true ->
        default
    end
  end

  defp get_nanosecond(map, default) do
    cond do
      Dict.has_key?(map, "SSSSSSSSS") ->
        {nanosecond, _} = Integer.parse(Dict.get(map, "SSSSSSSSS"))
        nanosecond

      Dict.has_key?(map, "SSSSSS") ->
        {microsecond, _} = Integer.parse(Dict.get(map, "SSSSSS"))
        microsecond * 1_000

      Dict.has_key?(map, "SSS") ->
        {millisecond, _} = Integer.parse(Dict.get(map, "SSS"))
        millisecond * 1_000_000

      Dict.has_key?(map, "SS") ->
        {centisecond, _} = Integer.parse(Dict.get(map, "SS"))
        centisecond * 10_000_000

      Dict.has_key?(map, "S") ->
        {decisecond, _} = Integer.parse(Dict.get(map, "S"))
        decisecond * 100_000_000

      true ->
        default
    end
  end

  defp get_offset(map, default) do
    cond do
      Dict.has_key?(map, "Z") ->
        offset = Dict.get(map, "Z")
        parse_offset(String.slice(offset, 0..0), String.slice(offset, 1..2), String.slice(offset, 4..5))

      Dict.has_key?(map, "ZZ") ->
        offset = Dict.get(map, "ZZ")
        parse_offset(String.slice(offset, 0..0), String.slice(offset, 1..2), String.slice(offset, 3..4))

      true ->
        default
    end
  end

  defp parse_offset("+", hour_str, minute_str) do
    {h, _} = Integer.parse(hour_str)
    {m, _} = Integer.parse(minute_str)
    (h * 60 + m)
  end

  defp parse_offset("-", hour_str, minute_str) do
    {h, _} = Integer.parse(hour_str)
    {m, _} = Integer.parse(minute_str)
    -(h * 60 + m)
  end
end
