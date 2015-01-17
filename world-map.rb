# -*- coding: utf-8 -*-
require_relative 'region.rb'
require_relative 'super-region.rb'
require_relative 'server-settings.rb'

class WorldMap
  attr_accessor :super_regions, :regions, :my_regions

  def initialize(settings)
    @super_regions = []
    @regions = []
    @my_regions = []
    @settings = settings
  end

  def setup_line(raw_line)
    raise 'raw_line is not split on space' unless raw_line.kind_of?(Array)

    command = raw_line.shift
    case command
    when 'super_regions' then
      raw_line.each_index do |index|
        if index.even?
          @super_regions << SuperRegion.new(raw_line[index].to_i,
                                            raw_line[index + 1].to_i)
        end
      end

    when 'regions' then
      raw_line.each_index do |index|
        if index.even?
          region = Region.new(raw_line[index].to_i,
                              @super_regions[raw_line[index + 1].to_i - 1])
          @regions << region
          region.super_region.push_region(region)
        end
      end

    when 'neighbors' then
      raw_line.each_index do |index|
        if index.even?
          region_id, neighbours = raw_line[index].to_i, raw_line[index + 1]
          neighbours = neighbours.split(',').map do |neighbour|
            c = @regions[neighbour.to_i - 1]
            c.append_neighbours(@regions[region_id - 1])
            c
          end
          @regions[region_id - 1].append_neighbours(neighbours)
        end
      end

    when 'wastelands' then
      raw_line.each_index do |index|
        @regions[raw_line[index].to_i - 1].owned_by = 'neutral'
      end

    when 'opponent_starting_regions' then
      raw_line.each_index do |index|
        @regions[raw_line[index].to_i - 1].owned_by = 'other'
      end

    else
      raise format('Unknown map command %s, see documentation.', command)
    end
  end

  def claim_region(region_id)
    @regions[region_id - 1].owned_by = @settings[:your_bot]
    @my_regions << @regions[region_id - 1]
  end

  def update_map(raw_line)
    while raw_line.length >= 3
      action = raw_line.shift(3)
      region_id, player_name, forces = action[0].to_i, action[1], action[2].to_i
      region = @regions[region_id - 1]

      if region.owned_by == @settings[:your_bot]
        @my_regions.delete(region) if player_name != @settings[:your_bot]
      else
        @my_regions.push(region) if player_name == @settings[:your_bot]
      end

      region.owned_by = player_name
      region.forces = forces
    end
  end

  def map_to_string()
    " == Regions == \n" +
    @regions.map do |region|
      region.id.to_s + (region.owned_by() == @settings[:your_bot] ? "y" : "o") +
      region.forces.to_s +
      " -> (" + region.neighbours.map{|neighbour| neighbour.id}.join(", ") + ")"
    end.join("\n") + "\n" +
    " == My Regions == \n" +
    @my_regions.map do |region|
      region.id.to_s + (region.owned_by() == @settings[:your_bot] ? "y" : "o") +
      region.forces.to_s +
      " -> (" + region.neighbours.map{|neighbour| neighbour.id}.join(", ") + ")"
    end.join("\n")
  end
end
