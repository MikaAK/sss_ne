defmodule SSSNE.Impls.TCEM.EncodingConfig do
  alias SSSNE.Impls.TCEM

  @type t :: %TCEM.EncodingConfig{
    input_component_count: integer,
    output_component_count: integer,
    component_count: integer,
    encoder: TCEM.ComponentEncoder.t,
    representation_mapper: TCEM.NetworkRepresentationMapper.t
  }

  @enforce_keys [
    :input_component_count,
    :output_component_count,
    :component_count,
    :encoder,
    :representation_mapper
  ]
  defstruct @enforce_keys

  def middle_node_count(%TCEM.EncodingConfig{
    input_component_count: input_count,
    output_component_count: output_count,
    component_count: component_count
  }), do: component_count - output_count - input_count
end
