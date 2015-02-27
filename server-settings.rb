# -*- coding: utf-8 -*-
class ServerSettings

  def initialize()
    @settings = {:opponent_bot => []}
  end

  def settings_line(raw_line)
    raise 'raw_line is not split on space' unless raw_line.kind_of?(Array)

    option = raw_line.shift
    case option
    when 'timebank'             then @settings[option.to_sym] =  raw_line[0].to_i
    when 'time_per_move'        then @settings[option.to_sym] =  raw_line[0].to_i
    when 'max_rounds'           then @settings[option.to_sym] =  raw_line[0].to_i
    when 'your_bot'             then @settings[option.to_sym] =  raw_line[0]
    when 'opponent_bot'         then @settings[option.to_sym] << raw_line[0]
    when 'starting_armies'      then @settings[option.to_sym] =  raw_line[0].to_i
    when 'starting_pick_amount' then @settings[option.to_sym] =  raw_line[0].to_i
    when 'starting_regions'     then
      @settings[option.to_sym] = raw_line.map{|value| value.to_i}
    else
      @settings[option.to_sym] = raw_line
      $stderr.puts(format('I got an unknown setting %s. Reffer to manual on theaigames.com.', option))
    end
  end

  def [](option)
    @settings[option]
  end
end
