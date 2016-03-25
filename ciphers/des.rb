require 'openssl'

data = File.read('./input.txt')


# cipher = OpenSSL::Cipher.new('AES-128-CBC')
# cipher.encrypt
# key = cipher.random_key
# iv = cipher.random_iv
#
# encrypted = cipher.update(data) + cipher.final
#
# decipher = OpenSSL::Cipher.new('AES-128-CBC')
# decipher.decrypt
# decipher.key = key
# decipher.iv = iv
#
# plain = decipher.update(encrypted) + decipher.final
#
# p plain
#
# puts data == plain #=> true

p OpenSSL::Cipher.ciphers

cipher = OpenSSL::Cipher.new('des3')
cipher.encrypt
key = cipher.random_key
iv = cipher.random_iv

encrypted = cipher.update(data) + cipher.final

decipher = OpenSSL::Cipher.new('des3')
decipher.decrypt
decipher.key = key
decipher.iv = iv

plain = decipher.update(encrypted) + decipher.final

p plain

puts data == plain #=> true