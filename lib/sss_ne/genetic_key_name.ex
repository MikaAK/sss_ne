defmodule SSSNE.GeneticKeyName do
  def parent_index_id(parent_id, index), do: "#{parent_id}-P#{index}"
  def gene_index_id(gene_id, index), do: "#{gene_id}-G#{index}"
end
