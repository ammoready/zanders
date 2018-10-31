require "spec_helper"
require "savon/mock/spec_helper"

describe Zanders::User do

  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '.new' do
    it 'requires a username and password' do
      expect { Zanders::User.new(username: 'usr') }.to raise_error(ArgumentError)
      expect { Zanders::User.new(password: 'psw') }.to raise_error(ArgumentError)
    end
  end

  describe '#authenticated?' do
    let(:user) { Zanders::User.new(username: 'usr', password: 'psw') }
    let(:fixture) { File.read(File.join(Dir.pwd, 'spec/fixtures/login_check.xml')) }

    before do
      savon.expects(:login_check).with(message: :any).returns(fixture)
    end

    it { expect(user.authenticated?).to be(true) }
  end

end
