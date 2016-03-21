# abc = ('A'..'Z').to_a
# k = 23
#
# name = 'IHORKROOSH'
#
# encoded = name
#   .chars
#   .map { |c| (((c[0].ord - 65) + k) % abc.length + 65).chr }
#   .join
#
# puts encoded
#
# decoded = encoded
#   .chars
#   .map { |c| (((c[0].ord - 65) - k) % abc.length + 65).chr }
#   .join
#
# puts decoded

module Ciphers
  module Caesar
    def self.encode(abc, text, shift)
      text = text.upcase
      abc_len = abc.length

      space_amount = 0
      text.chars.map.with_index do |char, index|
        char_index = abc.find_index(char)

        unless char_index
          space_amount += 1
          next char
        end

        abc[(shift + char_index) % abc_len]
      end.join
    end

    def self.decode(abc, text, shift)
      encode(abc, text.upcase, -shift)
    end
  end
end

# abc = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
#
# encoded = Ciphers::Caesar.encode(abc, 'Ihor Kroosh', 23)
# decoded = Ciphers::Caesar.decode(abc, encoded, 23)
#
# puts encoded, decoded