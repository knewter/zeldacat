defmodule Zeldacat.Mixfile do
  use Mix.Project

  def project do
    [ app: :zeldacat,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Zeldacat, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:exactor, github: "sasa1977/exactor"}
    ]
  end
end
