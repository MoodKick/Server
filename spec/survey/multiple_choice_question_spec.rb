require 'spec_helper'

require_relative 'shared_for_question'
require_relative 'shared_for_question_with_choices'

include Survey

describe MultipleChoiceQuestion do
  it_behaves_like 'a question'
  it_behaves_like 'a question with choices'
end
