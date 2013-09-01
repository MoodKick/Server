require_relative '../../app/models/content_object_scanner'

describe ContentObjectScanner do
  describe '#scan' do
    subject { ContentObjectScanner.new }
    let(:data1) do
      [
        {
          'external_html' => {
            'start' => 0,
            'end' => 5,
            'url' => 'slide1.html'
          }
        }
      ]
    end
    let(:data2) do
      [
        {
          'external_html' => {
            'start' => 0,
            'end' => 5,
            'url' => 'slide1.html'
          }
        }
      ]
    end

    it 'returns empty array for empty folder' do
      content_objects_path = File.expand_path File.dirname(__FILE__) + '../features/fixtures/empty_folder'
      subject.scan(content_objects_path).should == []
    end

    it 'returns array with attributes for every found content object' do
      content_objects_path = File.expand_path File.dirname(__FILE__) +
        '../../../features/fixtures/content_objects/'
      subject.scan(content_objects_path).should == [
        { 'title' => 'title1', 'name' => 'cob1', 'author' => 'author1', 'description' => 'description1', 'data' => data1 },
        { 'title' => 'title2', 'name' => 'cob2', 'author' => 'author2', 'description' => 'description2', 'data' => data2 }
      ]
    end

    it 'treats folders without manifest files as if they don\'t exist' do
      content_objects_path = File.expand_path File.dirname(__FILE__) +
        '../../../features/fixtures/content_objects_with_folder_with_broken_json/'
      subject.scan(content_objects_path).should == [
        { 'title' => 'title1', 'name' => 'cob1', 'author' => 'author1', 'description' => 'description1', 'data' => data1 },
        { 'title' => 'title2', 'name' => 'cob2', 'author' => 'author2', 'description' => 'description2', 'data' => data2 }
      ]
    end
  end
end
