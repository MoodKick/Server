require 'spec_helper'
require_relative 'shared_for_question_with_choices'
require_relative 'shared_for_question'

include Survey

describe SingleChoiceQuestion do
  it_behaves_like 'a question'
  it_behaves_like 'a question with choices'
end
