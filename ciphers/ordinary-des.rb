module Ciphers
  class DES
    PC_1 = [
      57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4
    ]
    PC_2  = [
      14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32
    ]
    CD_SHIFTS = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]
    INITIAL_PERMUTATIONS = [
      58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8, 57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19, 11, 3, 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7
    ]
    INVERSE_INITIAL_PERMUTATIONS = [
      40, 8, 48, 16, 56, 24, 64, 32, 39, 7, 47, 15, 55, 23, 63, 31, 38, 6, 46, 14, 54, 22, 62, 30, 37, 5, 45, 13, 53, 21, 61, 29, 36, 4, 44, 12, 52, 20, 60, 28, 35, 3, 43, 11, 51, 19, 59, 27, 34, 2, 42, 10, 50, 18, 58, 26, 33, 1, 41, 9, 49, 17, 57, 25
    ]
    E_BIT_SELECTION_TABLE = [
      32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9, 8, 9, 10, 11, 12, 13, 12, 13, 14, 15, 16, 17, 16, 17, 18, 19, 20, 21, 20, 21, 22, 23, 24, 25, 24, 25, 26, 27, 28, 29, 28, 29, 30, 31, 32, 1
    ]

    S_FUNCTIONS = [
      [[14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7], [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8], [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0], [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]],
      [[15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10], [3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5], [0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15], [13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9]],
      [[10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8], [13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1], [13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7], [1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12]],
      [[7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15], [13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9], [10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4], [3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14]],
      [[2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9], [14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6], [4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14], [11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3]],
      [[12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11], [10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8], [9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6], [4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13]],
      [[4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1], [13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6], [1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2], [6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12]],
      [[13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7], [1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2], [7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8], [2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11]]
    ]

    F_PERMUTATIONS = [
      16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25
    ]

    def self.encrypt(text, key, decrypt = false)
      key_in_binary = key.hex.to_s(2).chars[0..63].map(&:to_i)
      full_key_in_binary = [0] * (64 - key_in_binary.length) + key_in_binary

      text_in_binary = text.hex.to_s(2).chars.map(&:to_i)
      zeros_to_pad = text_in_binary.length % 64 == 0 ? 0 : (64 - (text_in_binary.length % 64))
      full_text_in_binary = [0] * zeros_to_pad + text_in_binary

      permutated_key = PC_1.map { |n| full_key_in_binary[n - 1] }

      cs, ds = CD_SHIFTS.each_with_object([
        [permutated_key[0..27]],
        [permutated_key[28..55]]
      ]) do |item, acc|
        acc[0] << cycle_shift_by(acc[0].last, item)
        acc[1] << cycle_shift_by(acc[1].last, item)
      end

      cds = cs[1..-1].zip(ds[1..-1]).map { |arrs| arrs[0] + arrs[1] }
      keys = cds.map do |cd|
        PC_2.map { |n| cd[n - 1] }
      end

      encoded_blocks = (full_text_in_binary.length / 64).times.to_a.map do |i|
        encode_block(
          full_text_in_binary[
            (i * 64)...((i + 1) * 64)
          ],
          keys,
          decrypt
        )
      end

      encoded_blocks.join.to_i(2).to_s(16)
    end

    def self.encode_block(block_to_encode, keys, decrypt)
      permutated_block = INITIAL_PERMUTATIONS.map { |n| block_to_encode[n - 1] }
      ls = [permutated_block[0...32]]
      rs = [permutated_block[32...64]]

      keys = keys.reverse if decrypt

      (1..16).to_a.map do |i|
        ls << rs[i - 1]
        rs << xor_bit_arrays(ls[i - 1], encoding_function(rs[i - 1], keys[i - 1]))
      end

      rl = (rs.last + ls.last)
      INVERSE_INITIAL_PERMUTATIONS.map { |n| rl[n - 1] }
    end

    def self.encoding_function(r_prev, k)
      e_r = E_BIT_SELECTION_TABLE.map { |n| r_prev[n - 1] }
      bs = xor_bit_arrays(e_r, k)
      ssed_bs = 8.times.flat_map do |i|
        bits = bs[(6 * i)...(6 * (i + 1))]
        first_last = ([bits.first] + [bits.last]).join.to_i(2)
        middle = bits[1..4].join.to_i(2)
        pad_left(S_FUNCTIONS[i][first_last][middle].to_s(2).chars.map(&:to_i), 4)
      end

      F_PERMUTATIONS.map { |n| ssed_bs[n - 1] }
    end

    def self.cycle_shift_by(array, n)
      array[n..array.length] + array.first(n)
    end

    def self.xor_bit_arrays(arr1, arr2)
      arr1.zip(arr2).map { |e1, e2| e1 == e2 ? 0 : 1 }
    end

    def self.pad_left(bin_arr, length)
      return bin_arr[0...length] if bin_arr.length > length
      [0] * (length - bin_arr.length) + bin_arr
    end
  end
end


# encoded = Ciphers::DES.encrypt('0123456789ABCDEF', '133457799BBCDFF1')
# puts encoded # => 85e813540f0ab405
# decoded = Ciphers::DES.encrypt(encoded, '133457799BBCDFF1', true)
# puts decoded # => 0123456789ABCDEF

def ascii_to_hex(text)
  text.chars.map(&:ord).map { |s| s.to_s(16) }.join
end

def ascii_from_hex(text)
  text.chars.each_slice(2).to_a.map(&:join).map(&:hex).map(&:chr).join
end

text = ascii_to_hex('ihor kroosh')
p text # => 69686f72206b726f6f7368
key = "seniordv".chars.map(&:ord).map { |s| s.to_s(16) }.join
encoded = Ciphers::DES.encrypt(text, key)
puts encoded # => 83be2947e29769d94b8d743bb45a0e7b
decoded = Ciphers::DES.encrypt(encoded, key, true)
puts decoded # => 69686f72206b726f6f7368
puts ascii_from_hex(decoded)

