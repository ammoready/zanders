require "spec_helper"
require "savon/mock/spec_helper"

describe Zanders::Address do

  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  let(:credentials) { { username: 'login', password: 'password' } }
  let(:address) { Zanders::Address.new(credentials) }
  let(:address_hash) do
    {
      name: 'Mindhunters',
      address1: '100 Pongo Dog Rd',
      address2: '',
      city: 'Plano',
      state: 'TX',
      zip: '12345',
      fflno: '10000008',
      fflexp: '2019-09-01'
    }
  end

  describe '#ship_to_number' do
    let(:ship_to_addresses) { FixtureHelper.get_fixture_file('ship_to_addresses.xml').read }

    it 'should have the correct `ship_to_number`' do
      savon.expects(:use_ship_to).with(message: :any).returns(ship_to_addresses)
      number = address.ship_to_number(address_hash)
      expect(number[:success]).to eq(true)
      expect(number[:ship_to_number]).to eq("9993")
    end
  end

end
