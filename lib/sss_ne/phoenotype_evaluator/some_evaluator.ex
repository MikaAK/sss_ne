defmodule SSSNE.PhenotypeEvaluator.SomeEvaluator do
  alias SSSNE.PhenotypeEvaluator

  @behaviour PhenotypeEvaluator

  @impl PhenotypeEvaluator
  def evaluate(genes), do: genes |> Map.values |> Enum.sum
end
