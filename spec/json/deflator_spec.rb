require 'spec_helper'
require 'oj'
require 'benchmark'

describe Json::Deflator do

  shared_context 'deflate validations' do
    shared_examples 'valid deflate' do
      specify 'has no exception' do
        expect{
          result = test_sample.deflate_json!(settings: test_settings)
        }.not_to raise_error        
      end
    end
    shared_examples 'integration test' do
      specify 'it matches original string' do
        decycled_result = test_sample.deflate_json!(settings: test_settings)
        decycled_string = decycled_result.to_json :max_nesting => 3000  
        # Inflate again
        recycled_result = decycled_result.inflate_json!(settings: test_settings)
        second_decycled_result = recycled_result
          .deflate_json!(settings: test_settings)
        second_decycled_string = second_decycled_result
          .to_json :max_nesting => 3000  

        expect( second_decycled_string )
          .to eq decycled_string
      end
    end
    # Units are milliseconds, please provide milliseconds
    shared_examples 'performance check' do | your_test, m_min_time, m_max_time |
      # Unit transform
      min_time = m_min_time / 1000.0
      max_time = m_max_time / 1000.0

      specify "#{your_test} takes between #{m_min_time} and #{m_max_time} ms" do
        expect( time ).to be_between(min_time, max_time), 
          "#{ time * 1000 } ms not in range( #{ m_min_time }, #{ m_max_time } ) ms"
      end
    end
    shared_examples 'deflate algorithm performance' do |mode, 
                                                          m_min_time, m_max_time|
      let(:time) {
        sample = test_sample
        Benchmark.realtime do
          result = sample.deflate_json!(settings: test_settings)
        end
      }
      
      it_behaves_like 'performance check', "deflate - #{ mode }", 
        m_min_time, m_max_time
    end
    shared_examples 'deflate w/json generate performance' do |mode, 
                                                            m_min_time, m_max_time|
      let(:time) {
        sample = test_sample
        Benchmark.realtime do
          result = sample.deflate_json!(settings: test_settings)
          JSON.generate result, max_nesting: false
        end
      }

      it_behaves_like 'performance check', "deflate - #{ mode } with json parse", 
        m_min_time, m_max_time
    end
    shared_examples 'deflate w/oj generate performance' do |mode, 
                                                          m_min_time, m_max_time|
      let(:time) {
        sample = test_sample
        Benchmark.realtime do
          result = sample.deflate_json!(settings: test_settings)
          Oj.dump result
        end
      }

      it_behaves_like 'performance check', "deflate - #{ mode } with oj parse", 
        m_min_time, m_max_time
    end
  end

  describe 'hash sample' do
    let(:test_sample) { array_with_circular_hashes_a }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
  end

  describe 'object sample' do
    let(:test_sample) { array_with_circular_objects_a }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
  end

  describe 'object sample 2' do
    let(:test_sample) { array_with_circular_objects_b }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
    end
  end

  describe 'object sample 3' do
    let(:test_sample) { array_with_circular_objects_c }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
      it_behaves_like 'deflate algorithm performance', 
        :j_path, 550, 920
      it_behaves_like 'deflate w/json generate performance', 
        :j_path, 600, 1300
      it_behaves_like 'deflate w/oj generate performance', 
        :j_path, 600, 1300
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
      it_behaves_like 'integration test'
      it_behaves_like 'deflate algorithm performance', 
        :static_reference, 200, 350
      it_behaves_like 'deflate w/json generate performance', 
        :static_reference, 350, 600
      it_behaves_like 'deflate w/oj generate performance', 
        :static_reference, 200, 400
    end
  end

end
