# -*- coding: utf-8 -*-
require_relative 'world-map.rb'
require_relative 'server-settings.rb'

class GameLogic

  def initialize(world_map, settings)
    @world_map = world_map
    @settings = settings
  end

  def server_says_go(next_line)
    command = next_line.shift
    time = next_line.shift

    case command
    when 'place_armies' then
      name = @settings[:your_bot]
      region = @world_map.my_regions.sample.id
      armies = @settings[:starting_armies]
      format('%s place_armies %i %i',
             name,
             region,
             armies)
    when 'attack/transfer' then
      attack_from = @world_map.my_regions.select{|region| region.forces > 1}
      attack_from.map do |region|
        format('%s attack/transfer %i %i %i',
               @settings[:your_bot],
               region.id,
               region.neighbours.sample.id,
               region.forces - 1)
      end.join(", ")
    else
      raise format('Unknown go command %s, please consult the manual', command)
    end
  end

  # Pick a starting region.
  #
  # This is very important and should be expanded when
  # time allows. For now, pick random. XD
  def pick_starting_region(raw_line)
    time = raw_line.shift
    region_id = raw_line.sample.to_i
    @world_map.claim_region(region_id)
    region_id
  end
end
