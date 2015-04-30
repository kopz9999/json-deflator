class Organization

  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :children
  attr_accessor :parent

  def initialize( name_val )
    self.name = name_val
    self.children = []
  end

  def add_child( child_org )
    child_org.parent = self
    self.children << child_org
  end

end