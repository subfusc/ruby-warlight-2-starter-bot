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
    @game_master = GameLogic.new(@world_map, @settings)
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
        when 'opponent_moves'       then next
        when 'pick_starting_region' then puts(@game_master.
                                               pick_starting_region(current_line))
        when 'go'                   then puts(@game_master.
                                               server_says_go(current_line) + ",")
        when 'Round', 'Output'      then next # This is only for test input
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
