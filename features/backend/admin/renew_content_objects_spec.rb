require_relative '../acceptance_helper'

describe 'Scan content objects', %q{
  As an Administrator,
  I want to be able to perform a Content Object Scan
  in order to have the system discover available COs for the Users to see
} do

  let(:repository) { ContentObjectRepository.new }
  let(:scanner) { ContentObjectScanner.new }

  subject { ContentObjectService.new(repository, scanner, content_objects_path) }

  before do
    2.times { ContentObject.create(title: 'stub', name: 'stub') }
  end

  class UpdateAllResponder
    def success
    end
  end

  describe 'Scan of folder with no content objects' do
    let(:content_objects_path) { __FILE__ + '../../fixtures/empty_folder' }

    it 'leaves content objects repository empty' do
      subject.update_all(UpdateAllResponder.new)

      repository.should have(0).items
    end
  end

  describe 'Scan of folder with 2 content objects' do
    let(:content_objects_path) { File.expand_path File.dirname(__FILE__) +
        '../../../../features/fixtures/content_objects/' }

    it 'persists all the content objects to the repository' do
      subject.update_all(UpdateAllResponder.new)

      repository.should have(2).items
    end
  end
end
