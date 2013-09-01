require 'spec_helper'

describe ContentObjectRepository do

  describe '#increase_launch_number' do
    let(:launch_number) { 23 }
    let(:content_object) do
      ContentObject.new do |o|
        o.name = 'cob1'
        o.launch_number = launch_number
      end
    end

    before do
      subject.add(content_object)
    end

    it 'adds 1 to launch_number of content object with given id' do
      subject.increase_launch_number(content_object.id)
      found = subject.find(content_object.id)
      found.launch_number.should == launch_number + 1
    end
  end

  describe '#udpate_all_with' do
    let(:title1) { 'cob1' }
    let(:name1) { 'name1' }
    let(:description1) { 'desc1' }
    let(:author1) { 'author1' }
    let(:data1) { [{'foo1' => 'bar1' }] }
    let(:type1) { 'sequential' }

    let(:title2) { 'cob2' }
    let(:name2) { 'name2' }
    let(:description2) { 'desc2' }
    let(:author2) { 'author2' }
    let(:data2) { [{'foo2' => 'bar2' }] }
    let(:type2) { 'timeline' }

    let(:content_object_attributes) do
      [
        { 'name' => name1, 'title' => title1, 'description' => description1, 'author' => author1, 'data' => data1, 'type' => type1 },
        { 'name' => name2, 'title' => title2, 'description' => description2, 'author' => author2, 'data' => data2, 'type' => type2 }
      ]
    end

    subject { ContentObjectRepository.new }

    context 'when there are no existing content objects' do
      before do
        subject.delete_all
        subject.update_all_with(content_object_attributes)
      end

      it 'creates from attributes' do
        content_objects = subject.all
        content_objects.size.should == 2

        content_objects.first.type.should == 'sequential'
        content_objects.first.title.should == title1
        content_objects.first.name.should == name1
        content_objects.first.data.should == data1
        content_objects.first.author.should == author1
        content_objects.first.description.should == description1

        content_objects.last.type.should == 'timeline'
        content_objects.last.title.should == title2
        content_objects.last.name.should == name2
        content_objects.last.data.should == data2
        content_objects.last.author.should == author2
        content_objects.last.description.should == description2
      end
    end

    context 'when there are existing content objects' do
      before do
        subject.delete_all
        subject.update_all_with(content_object_attributes)
      end

      it 'updates attributes of existing ones' do
        content_object_attributes.first['type'] = 'timeline'
        content_object_attributes.first['title'] = 'new title'
        content_object_attributes.first['author'] = 'new author'
        content_object_attributes.first['description'] = 'new description'
        content_object_attributes.first['data'] = [{'new' => 'data'}]
        subject.update_all_with(content_object_attributes)
        content_objects = subject.all
        content_objects.size.should == 2

        content_objects.first.title.should == 'new title'
        content_objects.first.data.should == [{'new' => 'data'}]
        content_objects.first.author.should == 'new author'
        content_objects.first.description.should == 'new description'
        content_objects.first.type.should == 'timeline'

        content_objects.last.title.should == title2
      end

      it 'deletes ones which are not found' do
        subject.add(ContentObject.new({
          title: 'title3',
          name: 'name3',
          data: [{'foo3' => 'bar3'}]
        }))
        subject.update_all_with(content_object_attributes)

        content_objects = subject.all
        content_objects.size.should == 2
        content_objects.detect { |c| c.name == 'name3' }.should be_nil
      end
    end
  end
end
