require "spec_helper"

describe Zanders::Inventory do

  let(:ftp) { instance_double('Net::FTP', :passive= => true, :debug_mode= => true) }
  let(:credentials) { { username: 'login', password: 'password' } }

  before do
    allow(Net::FTP).to receive(:open).with('ftp.host.com', 'login', 'password') { |&block| block.call(ftp) }
  end

  describe '.all' do
    let(:liveinv) { FixtureHelper.get_fixture_file('liveinv.xml') }

    before do
      allow(ftp).to receive(:chdir).with('Inventory/AmmoReady') { true }
      allow(ftp).to receive(:getbinaryfile) { nil }
      allow(ftp).to receive(:close) { nil }
      allow(Tempfile).to receive(:new).and_return(liveinv)
      allow(liveinv).to receive(:unlink) { nil }
    end

    it 'returns array of items' do
      items = Zanders::Inventory.all(credentials)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:item_identifier]).to  eq('000011')
          expect(item[:quantity]).to eq('10')
        when 1
          expect(item[:item_identifier]).to  eq('000012')
          expect(item[:quantity]).to eq('0')
        when 29
          expect(item[:item_identifier]).to  eq('000130')
          expect(item[:quantity]).to eq('24')
        end
      end

      expect(items.count).to eq(30)
    end
  end

end
