class Student < ApplicationRecord
  has_many :enrollments
  has_many :subjects, :through => :enrollments

  attr_accessor :raw_schedule

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

        result << subject_info
      end
      result
    rescue
      "DATA_IS_INVAILD"
    end
  end

  def get_subject_by_days(data = nil?)
    return "DATA_IS_INVAILD" if data.nil?

    data = parse_data_for_hcmus(data)
    return if data.eql?"DATA_IS_INVAILD"

    on = ["T2", "T3", "T4", "T5", "T6", "T7"]
    result = Array.new
    on.each do |on|
      days = Array.new
      data.select{|x| x[:on].eql? on}.each do |sbj|
        days << sbj
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

  def get_schedule(data = nil)
    return "DATA_IS_INVAILD" if data.nil?

    data = get_subject_by_days(data)

    list = Array.new(6)
    # Each days
    data.each_with_index do |v, index|
      next if (v.empty?) || (v.length == 0)
      result = Array.new
      clone = v
      sbj = clone[rand(clone.count)]

      if clone.length == 1
        data = delete_by_subject_name(sbj[:name], data)
        list[index] = sbj
        next
      end

      clone.delete_if {|a| a[:name] == sbj[:name]}
      atemp = Array.new

      loop do
        # Processed
        temp = rand(clone.count)
        next if atemp.include? temp
        atemp << temp
        break if atemp.length == clone.length
        next_sbj = clone[temp]
        next if next_sbj.nil?

        if !(sbj[:time].overlaps?next_sbj[:time])
          result << sbj
          result << next_sbj
          break
        end
      end

      # No result for combine subject
      if result.empty?
        # Get one
        sbj = v[rand(v.count)]
        result << sbj
        data = delete_by_subject_name(sbj[:name], data)
      else
        result.each { |e| data = delete_by_subject_name(e[:name], data) }
      end
      list[index] = result
    end

    #Re-Format list
    list.each do |t|
      t.each do |e|
        e[:time] = e[:on] <<"(" << e[:time].begin.to_s << "-" <<
        e[:time].end.to_s << ")"
        e.delete(:on)
        e.delete(:room)
      end
    end

    list
  end
end