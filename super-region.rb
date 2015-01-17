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
end
