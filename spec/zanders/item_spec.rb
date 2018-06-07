require 'spec_helper'
require "savon/mock/spec_helper"

describe Zanders::Item do

  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  let(:credentials) { { username: 'login', password: 'password' } }
  let(:item) { Zanders::Item.new(credentials) }

  describe '#get_info' do
    it 'gets the info' do
      savon.expects(:get_item_info).with(message: :any).returns(sample_item_info)
      info = item.get_info("GSPEC0595A")

      expect(info[:price]).to eq('255.0000')
      expect(info[:success]).to eq(true)
    end
  end

  describe '#get_quantity' do
    it 'gets the quantity' do
      savon.expects(:get_item_inventory).with(message: :any).returns(sample_item_quantity)
      quantity = item.get_quantity("GSPEC0595A")

      expect(quantity[:quantity]).to eq(58)
      expect(quantity[:success]).to eq(true)
    end
  end

end
