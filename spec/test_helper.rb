def build_organization_hash( opts )
  { name: nil, children: [], parent: nil }.merge( opts )
end

def add_hash_children( parent, child )
  parent[:children] << child
  child[:parent] = parent
end

### Test Cases Generators

def array_with_circular_hashes_a
  org1 = build_organization_hash name: "Test"
  org2 = build_organization_hash name: "Test A"
  org3 = build_organization_hash name: "Test B"
  org4 = build_organization_hash name: "Test C"
  org5 = build_organization_hash name: "Test D"
  org6 = build_organization_hash name: "Test E"

  add_hash_children org1, org2
  add_hash_children org1, org3
  add_hash_children org1, org4
  add_hash_children org5, org6

  [ org1, org2, org6 ]
end

def array_with_circular_objects_a
  org1 = Organization.new "Test"
  org2 = Organization.new "Test A"
  org3 = Organization.new "Test B"
  org4 = Organization.new "Test C"
  org5 = Organization.new "Test D"
  org6 = Organization.new "Test E"

  org1.add_child org2
  org1.add_child org3
  org1.add_child org4
  org5.add_child org6

  [ org1, org2, org6 ]
end

def array_with_circular_objects_b
  screw = Product.new.tap do |obj|
    obj.name = 'Screw'
    obj.price = 0.50
  end

  hammer = Product.new.tap do |obj|
    obj.name = 'Hammer'
    obj.price = 10
  end

  cooper = Material.new.tap do |obj|
    obj.name = 'Cooper'
    obj.weight = 324
    obj.cost = 45
  end

  wood = Material.new.tap do |obj|
    obj.name = 'Wood'
    obj.weight = 150
    obj.cost = 20
  end

  screw.add_material cooper

  hammer.add_material wood
  hammer.add_material cooper

  [ screw, hammer ]

end


