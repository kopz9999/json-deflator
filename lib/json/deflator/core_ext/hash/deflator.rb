class Hash

  include Json::Deflator::Deflatable

  protected

  def deflate_jpath!( opts = {} )
    base_path = Json::Deflator::ObjectManager.current_instance.current_path
    standard_filtering! opts
    self.each do | k, v |
      Json::Deflator::ObjectManager.current_instance.current_path = 
        "#{ base_path }.#{ k }"
      self[k] = v.deflate_json!(opts)
    end
  end

  def deflate_static_reference!( opts = {} )
    standard_filtering! opts
    self.each do | k, v |
      self[k] = v.deflate_json!(opts)
    end
  end

  def standard_filtering!( options )
    if options
      if attrs = options[:only]
        self.slice!(*Array(attrs))
      elsif attrs = options[:except]
        self.except!(*Array(attrs))
      end
    end
  end

end