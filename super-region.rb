# -*- coding: utf-8 -*-
require_relative 'land.rb'
require_relative 'region.rb'

class SuperRegion < Land
  attr_reader :bonus, :regions

  def initialize(id, bonus)
    super(id)
    @bonus = bonus
    @regions = []
  end

  def push_region(region)
    @regions << region
  end

  def calculate_neighbour_regions()
    @neighbours = @regions.map do |region|
      region.neighbours.select do |neighbour|
        neighbour.super_region != self
      end.map do |neighbour|
        neighbour.super_region
      end
    end.flatten.uniq
  end
end
