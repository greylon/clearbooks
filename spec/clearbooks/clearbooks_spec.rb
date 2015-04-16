require 'spec_helper'
require 'savon'

describe Clearbooks do
  let(:wsdl_url) { 'https://secure.clearbooks.co.uk/api/wsdl/' }
  
  before :all do
    @client = Savon::Client.new wsdl_url
  end

  describe "requests respond" do
    it "should connect successfully" do
      pending
    end

    it "should implement a connect method" do
      pending
    end

  end

end
