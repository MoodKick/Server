module Survey
  # single choice for multiple choice questions
  class Choice
    def initialize(params={})
      @value = params[:value]
      @id = params[:id]
    end

    attr_accessor :value, :id

    def ==(o)
      id == o.id &&
      value == o.value
    end
  end
end
