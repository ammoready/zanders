require "spec_helper"

describe Zanders::Address do

  let(:credentials) { { username: 'login', password: 'password' } }
  let(:address) { Zanders::Address.new(credentials) }

  describe '#initialize' do
    it { expect(address).to respond_to(:ship_to_number) }
  end

  describe '#ship_to_number' do
    address_hash = {
      name: 'BlackJack',
      address1: '13043 Pong Springs Rd',
      address2: '',
      city: 'Austin',
      state: 'TX',
      zip: '78729',
      fflno: '57406616',
      fflexp: '2019-09-01'
    }

    let(:number) { address.ship_to_number(address_hash) }

    it { expect(number[:success]).to eq(true) }

    it 'should have the correct `ship_to_number`' do
      expect(number[:ship_to_number]).to eq("0003")
    end
  end

end
