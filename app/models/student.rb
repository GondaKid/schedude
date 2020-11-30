class Student < ApplicationRecord
  has_many :enrollments
  has_many :subjects, :through => :enrollments

  attr_accessor :raw_schedule

  validates_length_of :student_id, :maximum => 10
  validates :student_id, :raw_schedule, presence: true
end