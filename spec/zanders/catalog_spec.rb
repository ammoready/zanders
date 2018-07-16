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

    it 'Yields each item to a block' do
      count = 0

      Zanders::Catalog.all(credentials) do |item|
        count += 1
        case count
        when 1
          expect(item[:upc]).to  eq('990000000100')
          expect(item[:name]).to eq('Loyalton')
        when 2
          expect(item[:upc]).to  eq('990000000200')
          expect(item[:name]).to eq('Kamba')
        when 30
          expect(item[:upc]).to  eq('990000000300')
          expect(item[:name]).to eq('Cogilith')
        end
      end

      expect(count).to eq(30)
    end
  end

end
