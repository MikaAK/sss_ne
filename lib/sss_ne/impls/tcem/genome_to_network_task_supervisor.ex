defmodule SSSNE.Impls.TCEM.GenomeToNetworkTaskSupervisor do
  use Task

  alias SSSNE.Impls.TCEM
  alias SSSNE.Impls.TCEM.ComponentDecoder

  def start_link(opts \\ []) do
    name_opt = {:name, TCEM.GenomeToNetworkTaskSupervisor}

    Task.Supervisor.start_link([name_opt | opts])
  end

  def convert_genome_to_network(
    genome,
    %TCEM.EncodingConfig{encoder: encoder} = encoding_config
  ) do
    components = ComponentDecoder.genome_to_components(encoder, genome)

    {inputs, middles, outputs} = ComponentDecoder.split_components(encoding_config, components)

    {
      ComponentDecoder.decode_input_components(encoding_config, inputs),
      ComponentDecoder.decode_middle_components(encoding_config, middles),
      ComponentDecoder.decode_output_components(encoding_config, outputs)
    }
  end
end
