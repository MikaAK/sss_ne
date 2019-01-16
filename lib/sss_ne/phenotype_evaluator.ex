defmodule SSSNE.PhenotypeEvaluator do
  @type t :: module

  @callback evaluate(any) :: any

  @spec evaluate(t, any) :: any
  def evaluate(module, genes), do: module.evaluate(genes)
end
