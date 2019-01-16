defmodule SSSNE.GenomeMutation do
  @type t :: module

  @callback mutate(any) :: any

  @spec mutate(t, any) :: any
  def mutate(module, param), do: module.mutate(param)
end
