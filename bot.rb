#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require_relative 'world-map.rb'
require_relative 'server-settings.rb'
require_relative 'game-logic.rb'

STDOUT.sync = true

class Bot

  def initialize()
    @settings = ServerSettings.new()
    @world_map = WorldMap.new(@settings)
    @game_master = GameLogic.new(@world_map)
  end

  def server_says_go(raw_line)
    command = raw_line.shift
    time    = raw_line.shift.to_i

    case command
    when 'place_armies' then
      response = @game_master.place_armies(time, @settings[:starting_armies])
      if response.nil? || response.empty?
        'No moves'
      else
        response.map do |placement|
          format('%s place_armies %i %i',
                 @settings[:your_bot],
                 placement[0],
                 placement[1])
        end.join(', ') + ', '
      end
    when 'attack/transfer'
      response = @game_master.attack_or_transfer(time)
      if response.nil? || response.empty?
        'No moves'
      else
        response.map do |move|
          format('%s attack/transfer %i %i %i',
                 @settings[:your_bot],
                 move[0],
                 move[1],
                 move[2])
        end.join(', ') + ', '
      end
    else
      raise format('Unknown go command %s, please consult the manual', command)
    end
  end

  def pick_starting_region(raw_line)
    @game_master.pick_starting_region(raw_line.shift.to_i, raw_line.map!{|id| id.to_i})
  end

  def run()
    while !$stdin.closed?
      begin
        current_line = $stdin.readline()
        next unless current_line
        current_line = current_line.strip().split()
        next if current_line.empty?  # Skip empty lines

        command = current_line.shift
        case command
        when 'setup_map'            then @world_map.setup_line(current_line)
        when 'settings'             then @settings.settings_line(current_line)
        when 'update_map'           then @world_map.update_map(current_line)
        when 'opponent_moves'       then next # To be implemented
        when 'Round', 'Output'      then next # This is only for test input
        when 'go'                   then puts(server_says_go(current_line))
        when 'pick_starting_region' then puts(pick_starting_region(current_line))
        else
          raise(format('Unknown top command %s, consult the manual on theaigames.com',
                       command))
        end

      rescue EOFError => eofError
        break
      end
    end
  end
end

if __FILE__ == $0
  Bot.new().run()
end
