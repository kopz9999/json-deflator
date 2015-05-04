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

# A Product, like a screw which can be composed of several materials
class Product
  attr_accessor :name
  attr_accessor :price
  attr_accessor :part_materials
  def initialize
    self.part_materials = []
  end
  def add_material( material )
    ctx = self
    self.part_materials << ProductMaterial.new.tap do |pm|
      pm.material = material
      pm.product = ctx
    end
  end
end

# A Material, which can be a component for several products
class Material
  attr_accessor :name
  attr_accessor :weight
  attr_accessor :cost
end

# A PartMaterial that makes a relationship between products and
# materials
class ProductMaterial
  attr_accessor :product
  attr_accessor :material
end

