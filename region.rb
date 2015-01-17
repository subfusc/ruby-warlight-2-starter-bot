# -*- coding: utf-8 -*-
require_relative 'land.rb'

class Region < Land
  attr_reader :super_region
  attr_accessor :owned_by, :forces

  def initialize(id, super_region)
    super(id)
    @super_region = super_region
    @owned_by = nil
    @forces = 0
  end
end
