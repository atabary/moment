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
