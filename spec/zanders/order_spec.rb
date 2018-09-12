require 'spec_helper'
require "savon/mock/spec_helper"

describe Zanders::Item do

  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  let(:items)   { 
    [
      {
        item_number: 'AA11',
        quantity: 1
      }, {
        item_number: 'BB22',
        quantity: 1
      }
    ]
  }

  let(:address) {
    {
      name:     'John Appleseed',
      address1: '1 McStreet St.',
      city:     'Happyville',
      state:    'SC',
      zip:      '12345'
    }
  }

  describe '#create_order' do

    context 'all good' do
      let(:order)   { Zanders::Order.new(username: 'user', password: 'pass') }
      let(:fixture) { File.read(File.join(Dir.pwd, 'spec/fixtures/order_response.xml')) }

      before do
        savon.expects(:create_order).with(message: :any).returns(fixture)
      end

      it 'parses the response' do
        response = order.create_order(items, address, '111-222', { name: 'John Appleseed', phone_number: '8885551234' })

        expect(response[:order_number]).to eq('111111')
        expect(response[:removed_items]).to eq(nil)
      end
    end

    context 'some of the items are not available' do
      let(:order)   { Zanders::Order.new(username: 'user', password: 'pass') }
      let(:fixture) { File.read(File.join(Dir.pwd, 'spec/fixtures/partial_order_response.xml')) }

      before do
        savon.expects(:create_order).with(message: :any).returns(fixture)
      end

      it 'parses the response' do
        response = order.create_order(items, address, '111-222', { name: 'John Appleseed', phone_number: '8885551234' })

        expect(response[:order_number]).to eq('111111')
        expect(response[:removed_items]).to be_a(Array)
      end
    end
  end

end
