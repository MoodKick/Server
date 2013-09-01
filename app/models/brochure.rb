# Non-personal article, like "Advice for relatives"
class Brochure < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  attr_accessible :body, :type
end
