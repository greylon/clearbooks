require 'spec_helper'
require 'savon'

module Clearbooks
  describe Clearbooks do
    describe :config do
      it 'has default WSDL url' do
        expect(Clearbooks.config.wsdl).to eq 'https://secure.clearbooks.co.uk/api/wsdl/'
      end
    end
  end
end

