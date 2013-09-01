# objects used to build slide-based presentations,
# either sequential - with next/previous states
# or timeline - slides change at some points in time
class ContentObject < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  attr_accessible :name, :type, :title, :data, :author, :description
  serialize :data
end
