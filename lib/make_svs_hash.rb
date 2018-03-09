word = /IDEOGRAPH-/
array = []
unified_code = []
compatibility_code = []
transarray = []
code = []
char = []
num = 0

File.open("StandardizedVariants.txt") do |file|
  file.each_line do |line|
    if line =~ word
      code = line.split(/(.*)\s(.*)(;\sCJK\sCOMPATIBILITY\sIDEOGRAPH-)(.*);/)
      char1 = "0x#{code[1]}"
      char1 = char1.to_i(16)
      char2 = "0x#{code[2]}"
      char2 = char2.to_i(16)
      char4 = "0x#{code[4]}"
      char4 = char4.to_i(16)
      char1 = [char1,char2].pack("U*")
      char4 = [char4].pack("U*")
      unified_code << char1
      compatibility_code << char4
    end
  end
end

unified_code.map!{|item|  item}
compatibility_code.map!{|item| item}

ary = [compatibility_code,unified_code].transpose
h = Hash[*ary.flatten]
File.open("svs_table.rb","w") do |f|
  f.puts("module Compatibility_to_Unified")
  f.puts("SVS_TABLE = {")
  h.each{|key, value|
    f.print( "\"#{key}\"=>\"#{value}\", ")
    num = num + 1
    if num == 8
      f.print("\n")
      num = 0
    end
  }
  f.puts("}")
  f.puts("SVS_TABLE.default_proc = ->(hsh, key) { key }")
  f.puts("end")
end
