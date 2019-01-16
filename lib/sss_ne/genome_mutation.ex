defmodule SSSNE.GenomeMutation do
  @type t :: module

  @callback mutate(any, String.t) :: any

  @spec mutate(t, integer, any) :: any
  def mutate(module, genes_id, genes), do: module.mutate(genes, genes_id)
end
