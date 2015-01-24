# -*- coding: utf-8 -*-
require_relative 'world-map.rb'
require_relative 'round.rb'

class GameLogic

  def initialize(world_map, round)
    @world_map = world_map # World Map
    @round = round # Round object, contains information about the current round
  end

  ##
  # Server askes for placements of armies with a time limit.
  #
  # Args:
  # +time+ => number of milliseconds the bot has to decide
  # +number_of_armies+ => The number of armies you can place this round.
  #
  # Output:
  # A list of placements given as a region id and the number of armies to place
  # in the current region.
  #
  # Example:
  # [[1, 3], [2, 2]]
  def place_armies(time)
    [[@world_map.my_regions.sample.id, @round.armies]]
  end

  ##
  # Server asks the bot to make its moves, i.e attack or transfer
  # between regions.
  #
  # Args:
  # +time+ => number of milliseconds the bot has to decide
  #
  # Output:
  # A list of attack or transfers to make represented with the country
  # to attack/transfer from, the country to attack/transfer to and the
  # number of forces.
  #
  # Example:
  # [[1, 3, 3], [4, 12, 6], [2, 6, 7]]
  def attack_or_transfer(time)
    attack_from = @world_map.my_regions.select{|region| region.forces > 1}
    attack_from.map {|region| [region.id, region.neighbours.sample.id, region.forces - 1]}
  end

  ##
  # Pick a starting region.
  #
  # Args:
  # +time+ => milliseconds to decide
  # +regions_ids+ => regions you can choose from. Array of ints
  #
  # Output:
  # The region id that you selected.
  #
  # Example:
  # 4
  def pick_starting_region(time, region_ids)
    region_ids.sample
  end
end
