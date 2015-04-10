require 'spec_helper'

describe Json::Deflator do
  it 'has a version number' do
    expect(Json::Deflator::VERSION).not_to be nil
  end

  it 'solves circular references in hashes' do
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

    elements = [ org1, org2, org6 ]

    binding.pry

  end

  it 'solves circular references in objects' do
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

    elements = [ org1, org2, org6 ]

    #binding.pry

    #expect(false).to eq(true)
  end
end
