defmodule SSSNE.GeneInitializer.SomeInitializer do
  alias SSSNE.GeneInitializer

  @behaviour GeneInitializer

  @impl GeneInitializer
  def random_init do
    Enum.random(-8..8)
  end
end
