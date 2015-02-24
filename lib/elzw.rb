
$VERBOSE = true

class Compresser
  def initialize_dictionary
    # initialize dictionary
    @proto_dict = {}
    @proto_decode_dict = {}
    for i in 0..25 do
      @proto_dict[(97+i).chr] = @proto_dict.length
      @proto_decode_dict[@proto_decode_dict.length] = (97+i).chr
    end
    @proto_dict[10.chr] = @proto_dict.length
    @proto_decode_dict[@proto_decode_dict.length] = 10.chr
  end

  def initialize(input, output)
    @input = input
    @output = output
    self.initialize_dictionary
  end

  def encode
    word = ''
    input_size = 0
    output_size = 0
    @input.each_char do |c|
      new_word = word + c
      input_size += 1
      if @proto_dict[new_word] == nil
        @proto_dict[new_word] = @proto_dict.length
        @output.write(@proto_dict[word].chr)
        output_size += 1
        new_word = c
      end
      word = new_word
    end
    @output.write(@proto_dict[word].chr)
    if $VERBOSE
      puts @proto_dict
      puts "compression: input size: #{input_size} => output size: #{output_size+1}"
      puts "compressed to #{100*(output_size+1)/(input_size)}% of original size"
    end
  end

  def decode
    old_i = nil
    input_size = 0
    output_size = 0
    @input.each_char do |c|
      input_size += 1
      i = c.ord.to_s(16).hex
      unless old_i == nil
        # append new word to end of dictionary
        if @proto_decode_dict[i] == nil
          @proto_decode_dict[@proto_decode_dict.length] = @proto_decode_dict[old_i] + @proto_decode_dict[old_i][0]
        else
          @proto_decode_dict[@proto_decode_dict.length] = @proto_decode_dict[old_i] + @proto_decode_dict[c.ord.to_s(16).hex][0]
        end
      end
      old_i = i
      decoded_string = @proto_decode_dict[old_i]
      output_size += decoded_string.length
      @output.write(decoded_string)
    end
    if $VERBOSE
      puts "decompression: input size: #{input_size} => output size: #{output_size}"
    end
  end
end



