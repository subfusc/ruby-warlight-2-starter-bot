# -*- coding: utf-8 -*-
require_relative 'server-settings.rb'

class Round
  attr_reader :round, :opponent_moves
  attr_accessor :super_region_changes

  def initialize(settings)
    @round = 0
    @settings = settings
    @opponent_moves = []
    @super_region_changes = {:lost => [], :gained => []}
  end

  def next_round()
    @round += 1
    @opponent_moves = []
  end

  def update_map()
    @super_region_changes = {:lost => [], :gained => []}
  end

  ##
  # Return the maximum number of rounds for this game
  def max_rounds()
    @settings[:max_rounds]
  end

  ##
  # Number of armies that can be placed this round
  def armies()
    @settings[:starting_armies]
  end

  def opponent_moves=(line)
    moves = []
    while not line.empty?
      name = line.shift
      command = line.shift
      case command
      when 'attack/transfer' then
        from, to, number = line.shift.to_i, line.shift.to_i, line.shift.to_i
        @opponent_moves << [from, to, number]
      when 'place_armies' then
        in_region, number = line.shift.to_i, line.shift.to_i
        @opponent_moves << [in_region, number]
      else
        raise format('Unknown command %s, Reffer to manual on theaigames.com', command)
      end
    end
  end
end
