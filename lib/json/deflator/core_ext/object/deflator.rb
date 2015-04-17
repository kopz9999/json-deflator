class Object

  def deflate_json!(opts = {})
    if respond_to?(:to_hash)
      to_hash.deflate_json!(opts.merge object_id: self.object_id)
    else
      instance_values.deflate_json!(opts.merge object_id: self.object_id)
    end
  end

end

class String
  def deflate_json!(opts = {})
    self
  end
end

class Numeric
  def deflate_json!(opts = {})
    self
  end
end

class NilClass
  def deflate_json!(opts = {})
    self
  end
end

class Symbol
  def deflate_json!(opts = {})
    self
  end
end

class TrueClass
  def deflate_json!(opts = {})
    self
  end
end

class FalseClass
  def deflate_json!(opts = {})
    self
  end
end
