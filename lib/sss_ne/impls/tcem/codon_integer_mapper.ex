defmodule SSSNE.Impls.TCEM.CodonIntegerMapper do
  # T Start
  def to_integer("TTT"), do: 0
  def to_integer("TTC"), do: 0

  def to_integer("TTA"), do: 1
  def to_integer("TTG"), do: 1

  def to_integer("TCC"), do: 2
  def to_integer("TCT"), do: 2
  def to_integer("TCA"), do: 2
  def to_integer("TCG"), do: 2

  def to_integer("TAT"), do: 3
  def to_integer("TAC"), do: 3

  def to_integer("TAA"), do: 9
  def to_integer("TAG"), do: 9

  def to_integer("TGT"), do: 4
  def to_integer("TGC"), do: 4

  def to_integer("TGG"), do: 9
  def to_integer("TGA"), do: 9

  # C Start
  def to_integer("CTT"), do: 1
  def to_integer("CTC"), do: 1
  def to_integer("CTA"), do: 1
  def to_integer("CTG"), do: 1

  def to_integer("CCC"), do: 5
  def to_integer("CCT"), do: 5
  def to_integer("CCA"), do: 5
  def to_integer("CCG"), do: 5

  def to_integer("CAC"), do: 6
  def to_integer("CAT"), do: 6

  def to_integer("CAA"), do: 7
  def to_integer("CAG"), do: 7

  def to_integer("CGC"), do: 8
  def to_integer("CGT"), do: 8
  def to_integer("CGA"), do: 8
  def to_integer("CGG"), do: 8

  # A Start
  def to_integer("ATT"), do: 10
  def to_integer("ATC"), do: 10

  def to_integer("ATA"), do: 9
  def to_integer("ATG"), do: 9

  def to_integer("ACC"), do: 11
  def to_integer("ACT"), do: 11
  def to_integer("ACA"), do: 11
  def to_integer("ACG"), do: 11

  def to_integer("AAC"), do: 12
  def to_integer("AAT"), do: 12

  def to_integer("AAA"), do: 13
  def to_integer("AAG"), do: 13

  def to_integer("AGC"), do: 2
  def to_integer("AGT"), do: 2

  def to_integer("AGA"), do: 8
  def to_integer("AGG"), do: 8

  # G Start
  def to_integer("GTT"), do: 14
  def to_integer("GTC"), do: 14
  def to_integer("GTA"), do: 14
  def to_integer("GTG"), do: 14

  def to_integer("GCC"), do: 15
  def to_integer("GCT"), do: 15
  def to_integer("GCA"), do: 15
  def to_integer("GCG"), do: 15

  def to_integer("GAC"), do: 16
  def to_integer("GAT"), do: 16

  def to_integer("GAA"), do: 17
  def to_integer("GAG"), do: 17

  def to_integer("GGC"), do: 18
  def to_integer("GGT"), do: 18
  def to_integer("GGA"), do: 18
  def to_integer("GGG"), do: 18
end
