class Subject < ApplicationRecord
  has_many :enrollments
  has_many :enrollments, :through => :enrollments
  
end
  