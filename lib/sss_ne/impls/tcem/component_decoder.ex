defmodule SSSNE.Impls.TCEM.ComponentDecoder do
  alias SSSNE.Impls.TCEM.EncodingConfig

  @type t :: module
  @type genome :: String.t
  @type components :: list(list(String.t))

  @callback genome_to_components(genome) :: components

  @callback decode_input_components(components, EncodingConfig.t) :: any
  @callback decode_output_components(components, EncodingConfig.t) :: any
  @callback decode_middle_components(components, EncodingConfig.t) :: any

  @callback create_network(inputs :: any, middles :: any, outputs :: any) :: any

  @callback split_components(components, EncodingConfig.t) ::
    {components, components, components}

  def decode_genome(%EncodingConfig{encoder: mod} = encoding_config, genome) do
    components = genome_to_components(mod, genome)

    network_args = encoding_config
      |> split_components(components)
      |> Tuple.to_list
      |> List.update_at(0, &decode_input_components(encoding_config, &1))
      |> List.update_at(1, &decode_middle_components(encoding_config, &1))
      |> List.update_at(2, &decode_output_components(encoding_config, &1))

    apply(mod, :create_network, network_args)
  end

  @spec genome_to_components(t, genome) :: components
  def genome_to_components(mod, genome) do
    mod.genome_to_components(genome)
  end

  @spec decode_input_components(EncodingConfig.t, components) :: any
  def decode_input_components(%EncodingConfig{encoder: mod} = encoding_config, components) do
    mod.decode_input_components(components, encoding_config)
  end

  @spec decode_output_components(EncodingConfig.t, components) :: any
  def decode_output_components(%EncodingConfig{encoder: mod} = encoding_config, components) do
    mod.decode_output_components(components, encoding_config)
  end

  @spec decode_middle_components(EncodingConfig.t, components) :: any
  def decode_middle_components(%EncodingConfig{encoder: mod} = encoding_config, components) do
    mod.decode_middle_components(components, encoding_config)
  end

  @spec split_components(EncodingConfig.t, components) :: {components, components, components}
  def split_components(%EncodingConfig{encoder: mod} = encoding_config, components) do
    mod.split_components(components, encoding_config)
  end
end
