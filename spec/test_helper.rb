def build_organization_hash( opts )
  { name: nil, children: [], parent: nil }.merge( opts )
end

def add_hash_children( parent, child )
  parent[:children] << child
  child[:parent] = parent
end