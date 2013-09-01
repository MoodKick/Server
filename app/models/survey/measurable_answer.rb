module Survey
  # Answer which can be measured in units
  class MeasurableAnswer < SingleValueAnswer
    def response
      value
    end
  end
end
