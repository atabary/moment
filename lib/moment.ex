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

  @doc """
  Returns the moment as an ISO8601 string.
  """
  def to_iso_string(moment) do
    case moment.offset do
      0 ->
        "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0wZ"
        |> :io_lib.format([moment.year, moment.month, moment.day, moment.hour, moment.minute, moment.second])
      _ ->
        offset_h = div(abs(moment.offset), 60)
        offset_m = rem(abs(moment.offset), 60)
        if moment.offset > 0 do
          "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0w+~.2.0w:~.2.0w"
        else
          "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0w-~.2.0w:~.2.0w"
        end
        |> :io_lib.format([moment.year, moment.month, moment.day, moment.hour, moment.minute, moment.second,
                           offset_h, offset_m])
    end
    |> :erlang.iolist_to_binary()
  end

  defp calc_offset(now) do
    local = now
    |> :calendar.now_to_local_time
    |> :calendar.datetime_to_gregorian_seconds

    universal = now
    |> :calendar.now_to_universal_time
    |> :calendar.datetime_to_gregorian_seconds

    div(local , 60) - div(universal, 60)
  end
end
