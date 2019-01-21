defmodule SSSNE.Impls.TCEM.NetworkRepresentationMapper do
  @type t :: module

  @callback representation_index(integer) :: any

  @spec representation_index(t, integer) :: any
  def representation_index(module, triple_codon_int) do
    module.representation_index(triple_codon_int)
  end
end
