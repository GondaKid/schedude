class Student < ApplicationRecord
  has_many :enrollments
  has_many :subjects, :through => :enrollments

  validates :student_id, presence: true

  def parse_data_for_hcmus(data = nil)
    return if data.nil?
    result = Array.new
    data.split("\n").each do |line|
      next if line.empty?
      lines = line.split("\t")
      times = lines[7].split(/[()]+/)

      subject_info = Hash.new
      subject_info[:code] = lines[0]
      subject_info[:name] = lines[1]
      subject_info[:on] = times[0]
      subject_info[:time]= times[1].split("-").first.to_i..times[1].split("-").last.to_i

      result << subject_info
    end

    result
  end

  def get_subject_by_days(data = nil)
    return if data.nil?

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

  def delete_by_subject_code(sbj, data = nil)
    arr = Array.new
    data.each do |e|
      arr << e.delete_if {|a| a[:code] == sbj}
    end
  end

  def get_schedule(data = nil)
    return "NO DATA" if data.nil?

    begin
      data = get_subject_by_days(parse_data_for_hcmus(data))
    rescue
      return "DATA IS INVAILD"
    end

    list = Array.new(6)
    # Each days
    data.each_with_index do |v, index|
      next if (v.empty?) || (v.length == 0)
      result = Array.new
      clone = v
      sbj = clone[rand(clone.count)]

      if clone.length == 1
          data = delete_by_subject_code(sbj[:code], data)
          list[index] = sbj
          next
      end

      clone.delete_if {|a| a[:code] == sbj[:code]}
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
        data = delete_by_subject_code(sbj[:code], data)
      else
        result.each {|e| data = delete_by_subject_code(e[:code], data)}
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