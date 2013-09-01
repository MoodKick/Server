require 'spec_helper'

describe BrochureRepository do
  before do
    subject.delete_all
  end

  describe 'update_by_type' do
    context 'when there is no brochure with such type' do
      it 'creates one with given body' do
        subject.update_by_type(:doesnt_exist, "I don't exist")
        subject.all.size.should == 1
        found = subject.all.first
        found.type.should == 'doesnt_exist'
        found.body.should == "I don't exist"
      end
    end

    context 'when there is one present' do
      before do
        subject.update_by_type(:exist, "I exist")
      end

      it 'udpates body' do
        subject.update_by_type(:exist, 'New body')
        subject.all.size.should == 1
        found = subject.all.first
        found.type.should == 'exist'
        found.body.should == 'New body'
      end
    end
  end

  describe 'by_type' do
    context 'when there is no brochure with such type' do
      it 'returns new brochure with empty body and given type' do
        brochure = subject.by_type(:doesnt_exist)
        brochure.body.should == ''
        brochure.type.should == 'doesnt_exist'
      end
    end

    context 'when there is a brochure with such type' do
      let(:body) { 'Body1' }
      before do
        subject.update_by_type(:exist, body)
      end

      it 'returns it' do
        brochure = subject.by_type(:exist)
        brochure.body.should == body
      end
    end
  end
end
