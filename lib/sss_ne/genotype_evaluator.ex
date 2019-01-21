defmodule SSSNE.GenotypeEvaluator do
  @type t :: module

  @callback evaluate(any, integer, map) :: any

  @spec evaluate(t, any, integer, map) :: any
  def evaluate(module, genes, trail_num, meta) do
    module.evaluate(genes, trail_num, meta)
  end
end
