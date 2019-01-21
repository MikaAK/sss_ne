defmodule SSSNE.Impls.TCEM.Mutation do
  @moduledoc """
  Triple Codon Encoding Method Mutation

  Contains Crossover and Mutation Operations
  """

  @crossover_keys [:move, :transform, :permutate]
  @mutation_keys [:reverse, :frequency, :add, :drop]

  def crossover_keys, do: @crossover_keys
  def mutation_keys, do: @mutation_keys

  def crossover(:move, genes) do
    genes
  end

  def crossover(:transform, genes) do
    genes
  end

  def crossover(:permutate, genes) do
    genes
  end

  def mutate(:reverse, genes) do
    genes
  end

  def mutate(:frequency, genes) do
    genes
  end

  def mutate(:add, genes) do
    genes
  end

  def mutate(:drop, genes) do
    genes
  end
end
