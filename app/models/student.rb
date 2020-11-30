class Student < ApplicationRecord
  has_many :enrollments
  has_many :subjects, :through => :enrollments

  validates_length_of :student_id, :maximum => 10
  validates :student_id, presence: true
end