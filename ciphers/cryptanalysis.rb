require_relative './caesar'


module Ciphers
  module Cryptanalysis
    ETAOIN = 'ETAOINSHRDLCUMWFGYPBVKJXQZ'.chars
    AZ = ('A'..'Z').to_a

    def self.get_chars_frequencies(abc, text)
      text = text.upcase
      text_len = text.length
      text.chars.each_with_object(abc.map { |c| [c, 0] }.to_h) do |c, f|
        f[c] += 1 if f[c]
      end.map { |k, v| [k, v / text_len.to_f * 100.0] }.to_h
    end

    def self.hack(str, abc)
      scores = AZ.length.times.map do |num|
        sorted_letters = get_chars_frequencies(
          abc, Ciphers::Caesar.decode(abc, str, num)
        ).sort { |f1, f2| f2[1] <=> f1[1] }.map { |(k, v)| k }
        first_six = sorted_letters[0..6]
        last_six = sorted_letters[-1..-6]
        matches_score =
          ETAOIN[0..6].reduce(0) { |acc, item| first_six.include?(item) ? acc + 1 : acc } +
          ETAOIN[-1..-6].reduce(0) { |acc, item| last_six.include?(item) ? acc + 1 : acc }

        [AZ[num], matches_score]
      end.to_h

      max = scores.max { |s1, s2| s1[1] <=> s2[1] }&.at(1)
      scores.partition { |score| score[1] == max }[0].map { |(k,v)| k }
    end
  end
end

abc = ('A'..'Z').to_a + ('0'..'9').to_a
text = File.read('./input.txt')
encoded = Ciphers::Caesar.encode(abc, text, 10)
p Ciphers::Cryptanalysis.hack(encoded, abc)
