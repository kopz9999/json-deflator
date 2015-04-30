require 'spec_helper'

describe Json::Deflator do

  shared_context 'deflate validations' do
    shared_examples 'valid deflate' do
      specify 'has no exception' do
        expect{
          test_sample.deflate_json!(settings: test_settings)
        }.not_to raise_error        
      end
    end
    shared_examples 'reference validation' do
    end
  end

  describe 'hash sample' do
    let(:test_sample) { array_with_circular_hashes_a }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
    end
  end

  describe 'object sample' do
    let(:test_sample) { array_with_circular_objects_a }

    include_context 'deflate validations'
    context 'with j_path' do
      let(:test_settings) { { mode: :j_path } }
      it_behaves_like 'valid deflate'
    end
    context 'with static_reference' do
      let(:test_settings) { { mode: :static_reference } }
      it_behaves_like 'valid deflate'
    end
  end

end
