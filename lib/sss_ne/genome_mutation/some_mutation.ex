defmodule SSNE.GenomeMutation.SomeMutation do
  alias SSSNE.GenomeMutation

  @behaviour GenomeMutation

  @impl GenomeMutation
  def mutate(params), do: params
end
