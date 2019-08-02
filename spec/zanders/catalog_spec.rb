require "spec_helper"

describe Zanders::Catalog do

  let(:ftp) { instance_double('Net::FTP', :passive= => true, :debug_mode= => true) }
  let(:credentials) { { username: 'login', password: 'password' } }

  before do
    allow(Net::FTP).to receive(:open).with('ftp.host.com', 'login', 'password') { |&block| block.call(ftp) }
  end

  describe '.all' do
    let(:zandersinv) { FixtureHelper.get_fixture_file('zandersinv.xml') }

    before do
      allow(ftp).to receive(:chdir).with('Inventory/AmmoReady') { true }
      allow(ftp).to receive(:getbinaryfile) { nil }
      allow(ftp).to receive(:close) { nil }
      allow(Tempfile).to receive(:new).and_return(zandersinv)
      allow(zandersinv).to receive(:unlink) { nil }
    end

    it 'returns an array of all items' do
      items = Zanders::Catalog.all(credentials)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:name]).to            eq('Loyalton')
          expect(item[:upc]).to             eq('990000000100')
          expect(item[:item_identifier]).to eq('000011')
          expect(item[:price]).to           eq('13.0')
          expect(item[:quantity]).to        eq('6')
          expect(item[:category]).to        eq('ACCESSORIES')
          expect(item[:brand]).to           eq('Skimia')
          expect(item[:caliber]).to         eq(nil)
        when 1
          expect(item[:name]).to              eq('Kaymbo WITH NIGHT SIGHTS')
          expect(item[:upc]).to               eq('990000000200')
          expect(item[:item_identifier]).to   eq('000012')
          expect(item[:price]).to             eq('464.0')
          expect(item[:quantity]).to          eq('0')
          expect(item[:category]).to          eq('PISTOL')
          expect(item[:brand]).to             eq('Kamba')
          expect(item[:features][:finish]).to eq('FLAT DARK EARTH')
        when 29
          expect(item[:name]).to            eq('Cogilith')
          expect(item[:upc]).to             eq('990000000300')
          expect(item[:item_identifier]).to eq('000130')
          expect(item[:price]).to           eq('78.0')
          expect(item[:quantity]).to        eq('6')
          expect(item[:category]).to        eq('ACCESSORIES')
          expect(item[:brand]).to           eq('Skimia')
        end
      end

      expect(items.count).to eq(30)
    end
  end

end
