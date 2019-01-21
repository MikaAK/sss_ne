defmodule SSSNE.Impls.TCEM.GenomeToNetworkTaskSupervisor do
  use Task

  alias SSSNE.Impls.TCEM
  alias SSSNE.Impls.TCEM.ComponentDecoder

  @name TCEM.GenomeToNetworkTaskSupervisor

  def start_link(opts \\ []) do
    name_opt = {:name, @name}

    Task.Supervisor.start_link([name_opt | opts])
  end

  def convert_genes_to_networks(genes) do
  end

  def convert_genome_to_network(genome, %TCEM.EncodingConfig{} = encoding_config) do
    task = Task.Supervisor.async_nolink(@name, fn ->
      ComponentDecoder.decode_genome(encoding_config, genome)
    end, timeout: :timer.seconds(30))

    Task.await(task)
  end
end
