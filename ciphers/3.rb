require 'openssl'

data = File.read('./input.txt')

pair = OpenSSL::PKey::RSA.new 2048
a = pair.public_encrypt('hello world this is text')
p a

b = pair.private_decrypt(a)
p b
