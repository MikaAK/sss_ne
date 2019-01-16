defmodule SSSNE.PhenotypeEvaluator do
  @type t :: module

  @callback evaluate(any, integer) :: any

  @spec evaluate(t, any) :: any
  def evaluate(module, genes, trail_num) do
    module.evaluate(genes, trail_num)
  end
end
