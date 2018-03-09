require "./svs_table.rb"
require "./Adobe_table.rb"
require "./Hanyo_table.rb"
include Compatibility_to_Unified
include Adobe_and_Hanyo_IVS

class Var
  def self.compatibility_to_unified(svs_str)
    svs_str.gsub(/([\u{F900}-\u{FAFF}|\u{2F000}-\u{2FFFF}])/, SVS_TABLE)
  end

  def self.adobe_to_hanyo(adobe_str)
    adobe_str.gsub(/(.[\u{E0100}-\u{E011F}])/, Adobe_to_Hanyo)
  end


  def self.hanyo_to_adobe(hanyo_str)
    hanyo_str.gsub(/(.[\u{E0100}-\u{E011F}])/, Hanyo_to_Adobe)
  end
end
