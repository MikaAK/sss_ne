defmodule SSSNE.GenotypeEvaluator do
  @type t :: module
  @type fitness :: integer

  @callback evaluate(any, integer, map) :: fitness

  @spec evaluate(t, any, integer, map) :: fitness
  def evaluate(module, genes, trail_num, meta) do
    module.evaluate(genes, trail_num, meta)
  end
end
