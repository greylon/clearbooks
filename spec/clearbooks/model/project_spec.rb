require 'spec_helper'
require 'savon'

module Clearbooks
  describe Clearbooks do

    # before(:all) { savon.mock! }
    # after(:all) { savon.unmock! }

    let(:message) { :any }

    describe '::create_project' do
      let(:project) do
        Project.new(description: 'Project 1 description',
                   project_name: 'Project 1 name',
                   status: 'open')
      end

      # let(:xml) { File.read('spec/fixtures/response/create_project.xml') }

      let(:response) do
        # savon.expects(:create_entity).with(message: message).returns(xml)
        Clearbooks.create_project(project)
      end

      it 'creates a new project' do
        expect(response).to be_a Hash
        expect(response[:project_id]).to be_a Fixnum
        expect(response[:project_id]).to be > 0
      end
    end

  end

end