defmodule SSSNE.Utils do
  def take_greater(item_a, item_b) when item_a >= item_b, do: item_a
  def take_greater(item_a, item_b) when item_a < item_b, do: item_b

  def random_float(min, max) do
    (max - min) * :rand.uniform() + min
  end

  def random_id, do: Base.encode32(:crypto.strong_rand_bytes(10))
end
