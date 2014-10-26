require 'spec_helper'

describe PushStarter do
  describe 'VERSION' do
    subject { PushStarter::VERSION }
    it { is_expected.to match /\A\d+\.\d+\.\d+\z/ }
  end
end
