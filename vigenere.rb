require 'set'
require './ciphers/caesar'

# ETAOIN = 'EeTtAaOoIiNnSsHhRrDdLlCcUuMmWwFfGgYyPpBbVvKkJjXxQqZz'.chars
ETAOIN = 'ETAOINSHRDLCUMWFGYPBVKJXQZ'.chars
AZ = ('A'..'Z').to_a

# abc = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
abc = ('A'..'Z').to_a + ('0'..'9').to_a
# engLetterFreq ={
#   e: 12.70, t: 9.06, a: 8.17, o: 7.51, i: 6.97, n: 6.75, s: 6.33, h: 6.09, r: 5.99, d: 4.25, l: 4.03, c: 2.78, u: 2.76, m: 2.41, w: 2.36, f: 2.23, g: 2.02, y: 1.97, p: 1.93, b: 1.29, v: 0.98, k: 0.77, j: 0.15, x: 0.15, q: 0.10, z: 0.07
# }


def encode(abc, text, word)
  text = text.upcase
  word = word.upcase
  abc_len = abc.length
  shifts = word.chars.map.with_index { |c| abc.find_index(c) }
  word_len = word.length

  space_amount = 0
  text.chars.map.with_index do |char, index|
    shift = shifts[(index - space_amount) % word_len]
    char_index = abc.find_index(char)

    unless char_index
      space_amount += 1
      next char
    end

    abc[(shift + char_index) % abc_len]
  end.join
end

# puts encode(abc, 'HELLO MY DEAR WORLD', 'KROOSH')

def decode(abc, text, word)
  text = text.upcase
  word = word.upcase
  abc_len = abc.length

  shifts = word.chars.map.with_index { |c| -abc.find_index(c) }
  word_len = word.length

  space_amount = 0
  text.chars.map.with_index do |char, index|
    shift = shifts[(index - space_amount) % word_len]
    char_index = abc.find_index(char)

    unless char_index
      space_amount += 1
      next char
    end

    abc[(shift + char_index) % abc_len]
  end.join
end

# puts decode(abc, 'RVZZ6 T8 USO9 3Y8ZR', 'Kroosh')

def get_chars_frequencies(abc, text)
  text = text.upcase
  text_len = text.length
  text.chars.each_with_object(abc.map { |c| [c, 0] }.to_h) do |c, f|
    f[c] += 1 if f[c]
  end.map { |k, v| [k, v / text_len.to_f * 100.0] }.to_h
end

def hack_vigenere(abc, encoded_text)
  encoded_text = encoded_text.upcase
  abc_text = encoded_text.gsub(/[^\w\d]/, '')
  p abc_text
  i = 0
  text_len = abc_text.length
  trigrams = Hash.new()
  progress = 1
  portion_size = (text_len / 20)

  print 'finding trigrams'
  until i >= text_len
    if i == portion_size * progress
      # print (((portion_size * progress) / text_len.to_f) * 100).ceil
      print '.....'
      progress += 1
    end

    trigram = abc_text[i..(i + 2)]

    trigrams[trigram] = Set.new([i]) unless trigrams[trigram]
    j = i + 3

    until j >= text_len
      if trigram == abc_text[j..(j + 2)]
        trigrams[trigram] << j
      end
      j += 1
    end

    i += 1
  end
  puts

  a = trigrams.lazy
    .select { |k, v| v.size > 5 }
    .flat_map do |k, v|
      poses = v.to_a.sort
      distances = poses.each_with_object([])
        .with_index { |(item, memo), index| memo << poses[index + 1] - item if poses[index + 1] }

      distances.flat_map.with_index do |pos, index|
        distances.map { |pos2| pos.gcd(pos2) }
      end
    end

  key_length = a.lazy.group_by { |i| i }.sort { |oc1, oc2| oc2[1].length <=> oc1[1].length }.first.first
  grouped_strings = abc_text.chars.group_by.with_index { |c, i| i % 6 }.map { |a| a.join }

  grouped_strings.map do |str|
  # str = grouped_strings[0]
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
  end#.join('')
end

def build_strings_from_tree(tree, str = '')
  return str unless tree&.at(0)

  tree[0].flat_map { |i| build_strings_from_tree(tree[1..-1], str + i) }
end

text = File.read('input.txt')
puts "**** TEXT ****"
puts text

puts "**** ENCODED TEXT ****"
encoded_text = encode(abc, text, 'KROOSH')
puts encoded_text

puts "*** CIPHER CODE ***"
build_strings_from_tree(hack_vigenere(abc, encoded_text)).each do |maybe_cipher|
  puts "*** MAYBE CIPHER ***"
  puts maybe_cipher
  puts "*** IT DECODES LIKE ***"
  puts decode(abc, encoded_text, maybe_cipher)
end
