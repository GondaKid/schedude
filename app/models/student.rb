class Student < ApplicationRecord
  belongs_to :school
  
  has_many :enrollments
  has_many :subjects, :through => :enrollments
end
