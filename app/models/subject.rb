class Subject < ApplicationRecord
  has_many :enrollments
  has_many :students, :through => :enrollments

  attr_accessor :on, :range

  after_initialize :set_time_on

  def set_time_on
    time_arr = time.split(/[()]+/)
    self.on = time_arr[0]
    self.range = time_arr[1].split("-").first.to_i..time_arr[1].split("-").last.to_i
  end
end

