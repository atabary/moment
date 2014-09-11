defmodule Moment.Formatter do

  @doc """
  Format moment according to format string.
  """
  def format(moment, format_str) do
    format(moment, format_str, "")
  end


  # Tail-recursive format
  # ---------------------

  defp format(moment, "YYYY" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.year))
  end

  defp format(moment, "YY" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(rem(moment.year, 100), 2))
  end

  defp format(moment, "Q" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(Moment.quarter(moment)))
  end

  defp format(moment, "MM" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.month, 2))
  end

  defp format(moment, "M" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.month))
  end

  defp format(moment, "DD" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.day, 2))
  end

  defp format(moment, "D" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.day))
  end

  defp format(moment, "HH" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.hour, 2))
  end

  defp format(moment, "H" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.hour))
  end

  defp format(moment, "mm" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.minute, 2))
  end

  defp format(moment, "m" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.minute))
  end

  defp format(moment, "ss" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.second, 2))
  end

  defp format(moment, "s" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(moment.second))
  end

  defp format(moment, "SSSSSSSSS" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(moment.nanosecond, 9))
  end

  defp format(moment, "SSSSSS" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(div(moment.nanosecond, 1_000), 6))
  end

  defp format(moment, "SSS" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(div(moment.nanosecond, 1_000_000), 3))
  end

  defp format(moment, "SS" <> rest, output_str) do
    format(moment, rest, output_str <> format_digits(div(moment.nanosecond, 10_000_000), 2))
  end

  defp format(moment, "S" <> rest, output_str) do
    format(moment, rest, output_str <> Integer.to_string(div(moment.nanosecond, 100_000_000)))
  end

  defp format(moment, "ZZ" <> rest, output_str) do
    format(moment, rest, output_str <> format_offset(moment, ""))
  end

  defp format(moment, "Z" <> rest, output_str) do
    format(moment, rest, output_str <> format_offset(moment, ":"))
  end

  defp format(moment, << h, rest :: binary >>, output_str) do
    format(moment, rest, output_str <> <<h>>)
  end

  defp format(_, "", output_str) do
    output_str
  end


  # Private
  # -------

  defp format_offset(moment, separator) do
    offset_h = format_digits(div(abs(moment.offset), 60), 2)
    offset_m = format_digits(rem(abs(moment.offset), 60), 2)
    sign = if moment.offset >= 0, do: "+", else: "-"
    "#{sign}#{offset_h}#{separator}#{offset_m}"
  end

  defp format_digits(i, n) do
    :io_lib.format("~.#{n}.0w", [i]) |> to_string()
  end

end
