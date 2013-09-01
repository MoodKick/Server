module Survey
  # question which answer can be measured in units
  class MeasurableQuestion < Question
    serialize :unit, Survey::Unit
  end
end
