defmodule SSSNE.GenomeMutation do
  @type t :: module

  @callback mutate(any, String.t, integer, map) :: any

  @spec mutate(t, any, String.t, integer, map) :: any
  def mutate(module, genes, new_parent_id, index, meta) do
    module.mutate(genes, new_parent_id, index, meta)
  end
end
