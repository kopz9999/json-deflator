class Array

  include Json::Deflator::Deflatable

  protected

  def deflate_jpath!( opts = {} )
    base_path = Json::Deflator::ObjectManager.current_instance.current_path
    self.map!.with_index do | obj, i |
      Json::Deflator::ObjectManager.current_instance.current_path = 
        "#{ base_path }[#{ i }]"
      obj.deflate_json!(opts)
    end
  end

  def deflate_static_reference!( opts = {} )

  end

end