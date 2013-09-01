module Survey
  # unit of measurement, with min value and max value
  class Unit

    #FIXME: serialization of ActiveRecord would call contructor without arguments
    #and than set attributes. I'd prefere this to be immutable
    def initialize(params={})
      @min_value = params[:min_value]
      @max_value = params[:max_value]
      @min_value_description = params[:min_value_description]
      @max_value_description = params[:max_value_description]
    end

    attr_accessor :min_value, :max_value, :min_value_description,
      :max_value_description

    def ==(o)
      min_value == o.min_value &&
      max_value == o.max_value &&
      min_value_description == o.min_value_description &&
      max_value_description == o.max_value_description
    end

    def default_value
      ((max_value - min_value) / 2).to_i + 1
    end
  end
end
