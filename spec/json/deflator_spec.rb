require 'spec_helper'

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

end
