defmodule SSSNE.Impls.TCEM.ComponentDecoder.SubNet do
  alias SSSNE.Impls.TCEM.{
    ComponentDecoder,
    EncodingConfig,
    CodonIntegerMapper,
    NetworkRepresentationMapper
  }

  @behaviour ComponentDecoder

  @component_length 3

  @impl ComponentDecoder
  def genome_to_components(genome) do
    genome
      |> String.split(" ")
      |> Enum.chunk_every(@component_length)
  end

  @impl ComponentDecoder
  def split_components(components, %EncodingConfig{
    input_component_count: input_count,
    component_count: components_count,
  }) do
    inputs_end_idx = input_count - 1
    middle_end_idx = components_count - inputs_end_idx

    inputs = Enum.slice(components, 0, inputs_end_idx)
    middles = Enum.slice(components, input_count, middle_end_idx)
    outputs = Enum.slice(components, inputs_end_idx + middle_end_idx)

    {inputs, middles, outputs}
  end

  @impl ComponentDecoder
  def decode_input_components(
    input_components,
    %EncodingConfig{
      input_component_count: input_node_count,
      representation_mapper: representation_mapper
    } = encoding_config
  ) do
    output_node_count = input_node_count + EncodingConfig.middle_node_count(encoding_config)

    # Thanks to @component_length we know the size of components
    Enum.reduce(input_components, %{}, fn ([codon_1, codon_2, codon_3], input_node_map) ->
      node_num = input_node_num(codon_1, input_node_count, input_node_map)
      output_num = input_and_middle_output_node_num(codon_3, input_node_count, output_node_count)
      representation = codon_to_representation(representation_mapper, codon_2)

      res = %{output: output_num, representation: representation}

      Map.put(input_node_map, node_num, res)
    end)
  end

  # Algorithm 1 - 1 -> 1 mapping for first triplet codon
  defp input_node_num(first_codon, input_num, node_map) when is_bitstring(first_codon) do
    input_node_num(CodonIntegerMapper.to_integer(first_codon), input_num, node_map)
  end

  defp input_node_num(first_codon_num, input_node_count, input_node_map) do
    num = Integer.mod(first_codon_num, input_node_count)

    if num in input_node_map do
      input_node_num(first_codon_num + 1, input_node_count, input_node_map)
    else
      num
    end
  end

  @impl ComponentDecoder
  def decode_middle_components(
    middle_components,
    %EncodingConfig{
      input_component_count: inputs_count,
      output_component_count: outputs_count,
      representation_mapper: representation_mapper
    } = encoding_config
  ) do
    middle_node_count = EncodingConfig.middle_node_count(encoding_config)
    input_middle_length = middle_node_count + inputs_count
    output_middle_length = middle_node_count + outputs_count

    Enum.into(middle_components, %{}, fn [codon_1, codon_2, codon_3] ->
      input_num = middle_and_output_input_node_num(codon_1, input_middle_length)
      output_num = input_and_middle_output_node_num(codon_3, inputs_count, output_middle_length)
      representation = codon_to_representation(representation_mapper, codon_2)

      {input_num, %{
        type: :middle,
        input: input_num,
        output: output_num,
        representation: representation
      }}
    end)
  end

  # Algorithm 3 - Regular mapping for last triple codon
  def input_and_middle_output_node_num(third_codon, num_inputs, possible_output_node_length) do
    Integer.mod(CodonIntegerMapper.to_integer(third_codon), possible_output_node_length) + num_inputs
  end

  @impl ComponentDecoder
  def decode_output_components(
    output_components,
    %EncodingConfig{
      input_component_count: inputs_count,
      output_component_count: outputs_count,
      representation_mapper: representation_mapper
    } = encoding_config
  ) do
    middle_node_count = EncodingConfig.middle_node_count(encoding_config)
    input_middle_count = middle_node_count + inputs_count

    Enum.reduce(output_components, %{}, fn ([codon_1, codon_2, codon_3], node_map) ->
      input_num = middle_and_output_input_node_num(codon_1, input_middle_count)
      representation = codon_to_representation(representation_mapper, codon_2)
      output_num = output_node_num(
        codon_3, inputs_count,
        middle_node_count,
        outputs_count, node_map
      )

      Map.put(node_map, input_num, %{
        type: :output,
        input: input_num,
        output: output_num,
        representation: representation
      })
    end)
  end

  # Algorithm 2 - Regular mapping for first triple codon
  def middle_and_output_input_node_num(codon, input_middle_length) do
    codon
      |> CodonIntegerMapper.to_integer
      |> Integer.mod(input_middle_length)
  end

  # Algorithm 4 - 1 -> 1 mapping for last triple codon
  def output_node_num(third_codon, input_num, middle_num, output_num) when is_bitstring(third_codon) do
    third_codon
      |> CodonIntegerMapper.to_integer
      |> output_node_num(input_num, middle_num, output_num)
  end

  def output_node_num(third_codon_num, input_num, middle_num, output_num, node_map) do
    num = Integer.mod(third_codon_num, output_num)

    if num in node_map do
      output_node_num(third_codon_num + 1, input_num, middle_num, output_num, node_map)
    else
      num + input_num + middle_num
    end
  end

  defp codon_to_representation(representation_mapper, codon) do
    codon_int = CodonIntegerMapper.to_integer(codon)

    NetworkRepresentationMapper.representation_index(representation_mapper, codon_int)
  end
end
