# -*- coding: utf-8 -*-
require_relative 'region.rb'
require_relative 'super-region.rb'
require_relative 'server-settings.rb'

class WorldMap
  attr_accessor :super_regions, :my_super_regions, :regions, :my_regions

  def initialize(round, settings)
    @super_regions = []
    @regions = []
    @my_regions = []
    @my_super_regions = []
    @visible_regions = []
    @settings = settings
    @round = round
  end

  def owned_by_symbol(player_name)
    case player_name
    when @settings[:your_bot] then :me
    when @settings[:opponent_bot][0] then :enemy
    when 'neutral' then :neutral
    else raise(format('unsupported players: %s', player_name))
    end
  end

  def update_map(raw_line)
    @round.update_map()
    @visible_regions = []
    while raw_line.length >= 3
      action = raw_line.shift(3)
      region_id, player_name, forces = action[0].to_i, action[1], action[2].to_i
      region = @regions[region_id - 1]
      now_owned_by = owned_by_symbol(player_name)

      region.forces = forces
      if region.owned_by == :me
        lost_region(region)  if now_owned_by != :me
      else
        claim_region(region) if now_owned_by == :me
      end

      @visible_regions << region
    end

    (@my_regions - @visible_regions).each{|region| lost_region(region)}
  end

  def path_between_regions(start_region_id, end_region_id)
    @regions[start_region_id - 1].path_to{|region| end_region_id == region.id}
  end

  def map_to_string()
    " == Regions == \n" +
    @regions.map do |region|
      region.id.to_s + (region.owned_by == :me ? "y" : "o") +
      region.forces.to_s +
      " -> (" + region.neighbours.map{|neighbour| neighbour.id}.join(", ") + ")"
    end.join("\n") + "\n" +
    " == My Regions == \n" +
    @my_regions.map do |region|
      region.id.to_s + (region.owned_by == :me ? "y" : "o") +
      region.forces.to_s +
      " -> (" + region.neighbours.map{|neighbour| neighbour.id}.join(", ") + ")"
    end.join("\n")
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

      @regions.each{|r| r.owned_by = :neutral}
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
      @super_regions.each{|sr| sr.calculate_neighbour_regions()}

    when 'wastelands' then
      raw_line.each_index do |index|
        @regions[raw_line[index].to_i - 1].owned_by = :neutral
      end

    when 'opponent_starting_regions' then
      raw_line.each_index do |index|
        @regions[raw_line[index].to_i - 1].owned_by = :enemy
      end

    else
      raise format('Unknown map command %s, see documentation.', command)
    end
  end

  private

  def claim_region(region)
    region = @regions[region - 1] unless region.kind_of?(Region)
    region.owned_by = :me
    @my_regions << region

    # Check if we also claimed the super_region
    unless region.super_region.regions.any?{|r| r.owned_by != :me}
      @my_super_regions.push(region.super_region)
      @round.super_region_changes[:gained].push(region.super_region)
    end
  end

  def lost_region(region)
    region = @regions[region_id - 1] unless region.kind_of?(Region)
    region.owned_by = :enemy
    @my_regions.delete(region)

    # Check if we also lost a super-region
    if @my_super_regions.include?(region.super_region)
      @my_super_regions.delete(region.super_region)
      @round.super_region_changes[:lost].push(region.super_region)
    end
  end
end
