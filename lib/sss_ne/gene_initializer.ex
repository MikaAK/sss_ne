defmodule SSSNE.GeneInitializer do
  @type t :: module

  @callback random_init() :: any

  @spec random_init(t) :: any
  def random_init(module), do: module.random_init()
end
