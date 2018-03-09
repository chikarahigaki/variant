code = []
adobe_code = []
hanyo_code = []
adobe_hash = []
hanyo_hash = []
num = 0

File.open("./IVD_Sequences.txt") do |file|
  file.each_line do |line|
    if line =~ /E0(.*)Adobe-Japan1/
      code = line.split(/(.*)\s(.*);\s(.*);\s(.*)/)
      adobe_code[1] = code[1]
      adobe_code[2] = code[2]
      adobe_code[3] = code[3]
      adobe_code[4] = code[4]

      adobe_num = adobe_code[4].match(/CID\+(.*)/)
      adobe_num = adobe_num[1].to_i

      if adobe_num >= 1125 && adobe_num <= 7477
        hanyo = "JA"
      elsif adobe_num == 8284 || adobe_num == 8285 then
        hanyo = "JA"
      elsif adobe_num >= 14296 && adobe_num <= 15385 then
        hanyo = "JB"
      elsif adobe_num >= 21075 && adobe_num <= 23057 then
        hanyo = "JB"
      elsif adobe_num >= 7633 && adobe_num <= 7886 then
        hanyo = "FT"
      elsif adobe_num >= 7961 && adobe_num <= 8004 then
        hanyo = "FT"
      elsif adobe_num == 8266 || adobe_num == 8267 then
        hanyo ="FT"
      elsif adobe_num >= 16779 && adobe_num <= 17232 then
        hanyo = "JC"
      elsif adobe_num >= 20299 && adobe_num <= 20306 then
        hanyo = "JC"
      elsif adobe_num >= 21072 && adobe_num <= 21074 then
        hanyo = "JC"
      elsif adobe_num >= 17233 && adobe_num <= 19129 then
        hanyo = "JD"
      elsif adobe_num >= 20308 && adobe_num <= 20316 then
        hanyo = "JD"
      elsif adobe_num >= 20263 && adobe_num <= 20296
        hanyo = "HG"
      else
        hanyo = "nil"
      end

      find_string = /#{adobe_code[1]}(.*)#{hanyo}/

      File.open("./IVD_Sequences.txt") do |refile|
        refile.each_line do |reline|
          if reline =~ find_string
            hanyo_code = reline.split(/(.*)\s(.*);\s(.*);\s(.*)/)
            hanyo_id = hanyo_code[4]
            hanyo_id = hanyo_id[0,2]
            if hanyo == hanyo_id
              adobe1 = "0x#{adobe_code[1]}"
              adobe1 = adobe1.to_i(16)
              adobe2 = "0x#{adobe_code[2]}"
              adobe2 = adobe2.to_i(16)
              hanyo1 = "0x#{hanyo_code[1]}"
              hanyo1 = hanyo1.to_i(16)
              hanyo2 = "0x#{hanyo_code[2]}"
              hanyo2 = hanyo2.to_i(16)
              adobe_kanji = [adobe1,adobe2].pack("U*")
              hanyo_kanji = [hanyo1,hanyo2].pack("U*")
              adobe_hash << adobe_kanji
              hanyo_hash << hanyo_kanji

              ary = [adobe_hash,hanyo_hash].transpose
              h = Hash[*ary.flatten]
              File.open("Adobe_table.rb","w") do |f|
                f.puts("module Adobe_and_Hanyo_IVS")
                f.puts("Adobe_to_Hanyo = {")
                h.each{|key, value|
                  f.print(" \"#{key}\"=>\"#{value}\", ")
                  num = num + 1
                  if num == 8
                    f.print("\n")
                    num = 0
                  end
                }
                f.puts("}")
                f.puts("Adobe_to_Hanyo.default_proc = ->(hsh, key) { key }")
                f.puts("end")
              end
            end
          end
        end
      end
    end
  end
end
