# class Snake
#   attr_reader :length

#   def initialize
#     @length = 1
#   end

#   def snake
#     self
#   end

#   def length_redefign
#     puts length # => 1
#     length = 5
#     puts length # => 5
#     puts self.length # => 1
#   end
# end

# Snake.new.length_redefign

class A
  @@value = 1
  def self.value
    @@value
  end
end
A.value # => 1

class B < A
  @@value = 2
end

class C < A
  @@value = 3
end

p B.value # => 3
p A.value