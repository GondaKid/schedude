class Student < ApplicationRecord
  has_many :enrollments
  has_many :subjects, :through => :enrollments

  attr_accessor :raw_schedule

  validates_length_of :student_id, :maximum => 10
  validates :student_id, :raw_schedule, presence: true

  def parse_data_for_hcmus(data = nil?)
    return "DATA_IS_INVAILD" if data.nil?

    begin
      result = Array.new
      data.split("\n").each do |line|
        next if line.empty?
        lines = line.split("\t")
        times = lines[7].split(/[()]+/)

        subject_info = Hash.new
        subject_info[:code_name] = lines[0]
        subject_info[:code] = lines[2]
        subject_info[:name] = lines[1]
        subject_info[:on] = times[0]
        subject_info[:time]= times[1].split("-").first.to_i..times[1].split("-").last.to_i
        subject_info[:full_time] = lines[7].match(/.+?(?=-P)/)[0]

        result << subject_info
      end
      result
    rescue
      "DATA_IS_INVAILD"
    end
  end

  def get_subject_by_days(data = nil, exclude_day_and_time = nil)
    return "DATA_IS_INVAILD" if data.nil?
    data = parse_data_for_hcmus(data)
    return if data.eql?"DATA_IS_INVAILD"

    on = ["T2", "T3", "T4", "T5", "T6", "T7"]
    result = []
    on.each do |on|
      days = []
      if exclude_day_and_time.nil?
        data.select{|x| x[:on].eql? on}.each do |sbj|
          days << sbj
        end
      else
        exclude = exclude_day_and_time.select{|x| x[:on].eql? on}
        data.select{|x| x[:on].eql? on}.each do |sbj|
          if exclude.empty?
            days << sbj
          else
            exclude.each do |ex|
              days << sbj unless ((ex[:x].to_i..ex[:y].to_i).overlaps?sbj[:time])
            end
          end
        end
      end

      result << days
    end
    result
  end

  def delete_by_subject_name(sbj, data = nil)
    arr = Array.new
    data.each do |e|
      arr << e.delete_if { |a| a[:name] == sbj }
    end
  end

  def get_schedule(data = nil, exclude_day_and_time = nil)
    return "DATA_IS_INVAILD" if data.nil?

    data = get_subject_by_days(data, exclude_day_and_time)

    list = Array.new(6, [])

    # Each days
    data.each_with_index do |v, index|
      if (v.empty?) || (v.nil?)
        list[index] = []
        next
      end
      result = []
      clone = v
      sbj = clone[rand(clone.count)]

      if clone.length == 1
        data = delete_by_subject_name(sbj[:name], data)
        list[index] << sbj
        next
      end

      clone.delete_if {|a| a[:name] == sbj[:name]}
      atemp = []

      loop do
        break if atemp.length == clone.length
        temp = rand(clone.count)

        next_sbj = clone[temp]
        if atemp.include? temp
          next
        elsif sbj[:name].eql? next_sbj[:name] || next_sbj.nil?
          atemp << temp
          next
        end

        atemp << temp
        if !(sbj[:time].overlaps?next_sbj[:time])
          result << sbj
          result << next_sbj
          break
        end
      end

      # No result for combine subject
      if result.empty?
        # Get one
        result << sbj
        data = delete_by_subject_name(sbj[:name], data)
      else
        result.each { |e| data = delete_by_subject_name(e[:name], data) }
      end
      list[index] = result
    end

    list
  end
end