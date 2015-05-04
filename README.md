# Json::Deflator

This ruby gem actually contains the necessary logic to decycle a JSON object. 
This means that it removes circular references from a hash or object with cyclic
structures as parent-child pointers.

Let's take the following example:

```ruby
  
  require 'rails' # To have as_json

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

  [ screw, hammer ].as_json 
  # This will cause an error: SystemStackError: stack level too deep

```

In order to solve this problem, you can use Json::Deflator gem to decycle your data structure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json-deflator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-deflator

## Usage

### Quick Start

For the above example, just call the method #deflate_json!

```ruby

  results = [ screw, hammer ].deflate_json!
  # result contains:
  [
    {
      "part_materials"=>
        [
          {
            "material"=>{"name"=>"Cooper", "weight"=>324, "cost"=>45}, 
            "product"=>{"$ref"=>"$[0]"}
          }
        ], 
      "name"=>"Screw", "price"=>0.5
    },
    {
      "part_materials"=>
        [
          {
            "material"=>{"name"=>"Wood", "weight"=>150, "cost"=>20}, 
            "product"=>{"$ref"=>"$[1]"}
          }, 
          {
            "material"=>{"$ref"=>"$[0].part_materials[0].material"}, 
            "product"=>{"$ref"=>"$[1]"}
          }
        ], 
      "name"=>"Hammer", "price"=>10
    }
  ]
```

The decycling is done with JPath so you can recycle with:
* For JavaScript: https://github.com/douglascrockford/JSON-js
* For Ruby: https://github.com/kopz9999/json-inflator

### Decycle JPath (Default)

By default the parser will resolve references by JSON Path as in the above examples.
You can tell it to do it in a more explicit way:

```ruby
  results = [screw, hammer].deflate_json! settings: { mode: :j_path }
```

### Static Reference

Another proposal to resolve the circular references is to mark every object with an $id.

```ruby
  results = [screw, hammer].deflate_json! settings: { mode: :static_reference, 
    preserve_arrays: false }
  # result contains:
  [
    {
      "part_materials"=>
        [
          {
            "material"=>
              {"name"=>"Cooper", "weight"=>324, "cost"=>45, "$id"=>3}, 
            "product"=>{"$ref"=>1}, 
            "$id"=>2
          }
        ], 
      "name"=>"Screw", "price"=>0.5, "$id"=>1
    },
    {
      "part_materials"=>
        [
          {
            "material"=>
              {"name"=>"Wood", "weight"=>150, "cost"=>20, "$id"=>6}, 
            "product"=>{"$ref"=>4}, 
            "$id"=>5
          }, 
          {
            "material"=>{"$ref"=>3}, 
            "product"=>{"$ref"=>4}, 
            "$id"=>7
          }
        ], 
      "name"=>"Hammer", "price"=>10, "$id"=>4
    }
  ]
```

### Array Preservation
You can also track references for the arrays (which is done by default). 
<br/>
In the case of JPath, tracking references just gives you references ($ref) pointing not just to objects but to arrays.
<br/>
For Static Reference, you also have thes references pointing to arrays. In order to reference arrays, these ones are converted into hashes
with the following style:
```ruby
{
  '$values' => [1, 2, 3] # The array itself
  '$id' => 32 # Unique identifier for the array
}
```

The above example shall be transformed like:

```ruby

  results = [screw, hammer].deflate_json! settings: { mode: :static_reference, 
    preserve_arrays: true }
  # result contains:
  {
    "$values"=>
      [
        {
          "part_materials"=>
            {
              "$values"=>
              [
                {
                  "material"=>{
                    "name"=>"Cooper", "weight"=>324, "cost"=>45, "$id"=>5
                  },
                  "product"=>{"$ref"=>2},
                  "$id"=>4
                }
              ], 
              "$id"=>3
            }, 
            "name"=>"Screw", 
            "price"=>0.5, 
            "$id"=>2
        },
        {
          "part_materials"=>
            {
              "$values"=>
              [
                {
                  "material"=>{
                    "name"=>"Wood", "weight"=>150, "cost"=>20, "$id"=>9
                  }, 
                  "product"=>{"$ref"=>6},
                  "$id"=>8
                }, 
                {
                  "material"=>{"$ref"=>5},
                  "product"=>{"$ref"=>6},
                  "$id"=>10
                }
              ], 
              "$id"=>7
            }, 
          "name"=>"Hammer", 
          "price"=>10,
          "$id"=>6
        }
      ],
    "$id"=>1
  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/json-deflator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
