


class Compresser
  def initialize(input, output)
    @input = input
    @output = output

    @proto_dict = {}
    @proto_decode_dict = {}
    for i in 0..25 do
      @proto_dict[(97+i).chr] = @proto_dict.length
      @proto_decode_dict[@proto_decode_dict.length] = (97+i).chr
    end
    @proto_dict[10.chr] = @proto_dict.length
    @proto_decode_dict[@proto_decode_dict.length] = 10.chr
  end

  def encode
    word = ''
    @input.each_char do |c|
      new_word = word + c
      if @proto_dict[new_word] == nil
        @proto_dict[new_word] = @proto_dict.length
        @output.write(@proto_dict[word].chr)
        new_word = c
      end
      word = new_word
    end
    @output.write(@proto_dict[word].chr)
  end

  def decode
    old_i = nil
    @input.each_char do |c|
      i = c.ord.to_s(16).hex
      unless old_i == nil
        # append new word to end of dictionary
        puts(@proto_decode_dict[old_i])
        if @proto_decode_dict[i] == nil
          @proto_decode_dict[@proto_decode_dict.length] = @proto_decode_dict[old_i] + @proto_decode_dict[old_i][0]
        else
          @proto_decode_dict[@proto_decode_dict.length] = @proto_decode_dict[old_i] + @proto_decode_dict[c.ord.to_s(16).hex][0]
        end
        puts @proto_decode_dict
      end
      old_i = i
      @output.write(@proto_decode_dict[old_i])
    end
  end
end

inf_name = '../test_infile.txt'
outf_name = '../test_outfile.txt'
outf_name2 = '../test_outfile2.txt'
en_inf = File.new(inf_name, 'r')
en_outf = File.new(outf_name, 'w')
Compresser.new(en_inf, en_outf).encode()
en_inf.close
en_outf.close

de_inf = File.new(outf_name, 'r')
de_outf = File.new(outf_name2, 'w')
Compresser.new(de_inf, de_outf).decode()
de_inf.close
de_outf.close


