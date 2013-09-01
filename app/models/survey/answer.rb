module Survey
  # Superclass for answers
  class Answer < ActiveRecord::Base
    belongs_to :question
  end
end
