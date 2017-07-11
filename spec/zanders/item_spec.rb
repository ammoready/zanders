require 'spec_helper'

describe Zanders::Item do

  let(:credentials) { { username: 'login', password: 'password' } }
  let(:item) { Zanders::Item.new(credentials) }

  describe '#initialize' do
    it { expect(item).to respond_to(:get_info) }
    it { expect(item).to respond_to(:get_quantity) }
  end

  describe '#get_info' do
    let (:info) { item.get_info("GSPEC0595A") }

    it { expect(info[:success]).to eq(true) }
  end

  describe '#get_quantity' do
    let (:quantity) { item.get_quantity("GSPEC0595A") }

    it { expect(quantity[:success]).to eq(true) }
  end

end
