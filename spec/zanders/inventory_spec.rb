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

    it 'Yields each item to a block' do
      count = 0

      Zanders::Inventory.all(credentials) do |item|
        count += 1
        case count
        when 1
          expect(item[:item_identifier]).to  eq('000011')
          expect(item[:quantity]).to eq('10')
        when 2
          expect(item[:item_identifier]).to  eq('000012')
          expect(item[:quantity]).to eq('0')
        when 30
          expect(item[:item_identifier]).to  eq('000130')
          expect(item[:quantity]).to eq('24')
        end
      end

      expect(count).to eq(30)
    end
  end

end
