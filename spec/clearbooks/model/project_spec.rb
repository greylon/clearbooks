require 'spec_helper'
require 'savon'

module Clearbooks
  describe Clearbooks do

    before(:all) { savon.mock! }
    after(:all) { savon.unmock! }

    let(:message) { :any }

    describe '::create_project' do
      let(:project) do
        Project.new(description: 'Project 1 description',
                   project_name: 'Project 1 name',
                   status: 'open')
      end

      let(:xml) { File.read('spec/fixtures/response/create_project.xml') }

      let(:response) do
        savon.expects(:create_project).with(message: message).returns(xml)
        Clearbooks.create_project(project)
      end

      it 'creates a new project' do
        expect(response).to be_a Hash
        expect(response[:project_id]).to be_a Fixnum
        expect(response[:project_id]).to be > 0
      end
    end

    describe '::list_projects' do
      let(:xml) { File.read('spec/fixtures/response/projects.xml') }

      let(:projects) do
        savon.expects(:list_projects).with(message: message).returns(xml)
        Clearbooks.list_projects
      end

      it 'returns list of projects' do
        expect(projects).to be_an Array
         expect(projects.length).to eq 3
      end

      describe Project do
        let(:project) {projects.last}

        it 'is a Project' do
          expect(project).to be_a Project
        end

        it 'has proper attribute values' do
          expect(project.project_name).to eq 'Project 3 name'
          expect(project.status).to eq 'open'
          expect(project.description).to eq 'description3'
          expect(project.id).to eq 3
        end
      end
    end

  end

end
