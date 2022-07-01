# frozen_string_literal: true

#
# SimpleCollection object to use to display in the collections page
# For the top level campus object, slug will be id and name is the title
#
class SimpleCollection
  attr_reader :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def to_partial_path
    'collections/collection'
  end
end
