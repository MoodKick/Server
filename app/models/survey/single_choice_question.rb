module Survey
  Choice # autoload it

  # answer with single choice answer
  class SingleChoiceQuestion < Question
    serialize :choices, Array

    def add_choice(choice)
      get_choices << choice
    end

    def choice_by_id(choice_id)
      get_choices.to_a.find { |ch| ch.id == choice_id }
    end

    private
      def get_choices
        self.choices ||= []
      end
  end
end
