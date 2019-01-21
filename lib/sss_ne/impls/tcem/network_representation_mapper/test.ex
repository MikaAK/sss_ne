defmodule SSSNE.Impls.TCEM.NetworkRepresentationMapper.Test do
  alias SSSNE.Impls.TCEM.NetworkRepresentationMapper

  @behaviour NetworkRepresentationMapper

  @impl NetworkRepresentationMapper
  def representation_index(0), do: %{node_connections: [:input, :output]}
  def representation_index(1), do: %{node_connections: [:input, 0, :output]}
  def representation_index(2), do: %{node_connections: [:input, [0, 1], :output]}
  def representation_index(3), do: %{node_connections: [:input, [0, 1, :output], :output]}
  def representation_index(4), do: %{node_connections: [:input, [0, 1, 2], :output]}
  def representation_index(5), do: %{node_connections: [:input, [0, [1, 0]], :output]}
  def representation_index(6), do: %{node_connections: [:input, [[0, 1], 1, 2], :output]}
  def representation_index(7), do: %{node_connections: [:input, 1, 2, :output]}
  def representation_index(8), do: %{node_connections: [:input, [:output, 0], :output]}
  def representation_index(9), do: %{node_connections: [:input, 0, [[1, 2], 2], :output]}
  def representation_index(10), do: %{node_connections: [:input, [0, [1, 2]], :output]}
  def representation_index(11), do: %{node_connections: [:input, 0, [1, 2], :output]}
  def representation_index(12), do: %{node_connections: [:input, 0, [1, :output, 2], :output]}
  def representation_index(13), do: %{node_connections: [:input, [0, [1, :output, 2]], :output]}
  def representation_index(14), do: %{node_connections: [:input, [[0, 2], [1, 0, 2], 2], :output]}
  def representation_index(15), do: %{node_connections: [:input, [0, 1], 2, :output]}
  def representation_index(16), do: %{node_connections: [:input, [[0, :output], [1, 0]], 2, :output]}
  def representation_index(17), do: %{node_connections: [:input, [0, [1, [0, 2]], 2], :output]}
  def representation_index(18), do: %{node_connections: [:input, [0, 1, 2], 2, :output]}
end
