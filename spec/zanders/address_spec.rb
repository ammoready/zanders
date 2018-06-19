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
      name: 'BlackJack',
      address1: '13043 Pong Springs Rd',
      address2: '',
      city: 'Austin',
      state: 'TX',
      zip: '78729',
      fflno: '57406616',
      fflexp: '2019-09-01'
    }
  end

  describe '#ship_to_number' do
    it 'should have the correct `ship_to_number`' do
      savon.expects(:use_ship_to).with(message: :any).returns(sample_ship_to_addresses)
      number = address.ship_to_number(address_hash)
      expect(number[:success]).to eq(true)
      expect(number[:ship_to_number]).to eq("0003")
    end
  end

end
