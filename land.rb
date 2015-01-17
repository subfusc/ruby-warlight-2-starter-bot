# -*- coding: utf-8 -*-
class Land
  attr_reader :id, :neighbours

  def initialize(id)
    @id = id
    @neighbours = []
  end

  def append_neighbours(neighbours)
    if neighbours.kind_of?(Array)
      @neighbours += neighbours
    else
      @neighbours << neighbours
    end
  end
end
