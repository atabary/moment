defmodule Calendar.Mixfile do
  use Mix.Project

  def project do
    [app: :moment,
     version: "0.0.1",
     elixir: ">=1.0.0",
     package: package,
     description: "Parse, validate, manipulate, and display dates in Elixir.",
     docs: [readme: true, main: "README"]]
  end

  defp package do
    %{licenses: ["Apache 2"],
      links: %{"Github" => "https://github.com/atabary/moment"}}
  end
end
