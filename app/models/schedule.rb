class Schedule
  def initialize data, i_sbj, i_time
    @raw_data = data
    @i_sbj = i_sbj
    @i_time = i_time
  end

  def any_overlapping_ranges(array_of_ranges)
    array_of_ranges.sort_by(&:first).each_cons(2).any?{|x,y|x.last>y.first}
  end

  def parse_data_for_hcmus(data = nil)
    return if data.nil?

    result = Array.new

    data.split("\n").each do |line|
      next if line.empty?

      lines = line.split("\t")

      times = if(!lines[7].is_a? Numeric)
                lines[7].split(/[()]+/)
              else
                lines[8].split(/[()]+/)
              end

      subject_info = Hash.new
      subject_info[:code] = lines[0]
      subject_info[:name] = lines[1]
      subject_info[:on] = times[0]
      subject_info[:time]= times[1].split("-").first.to_i..times[1].split("-").last.to_i

      result << subject_info
    end

    # List all subject {:code, :name, :on => T2/T3/T4/..., :time => 1..10}
    return result
  end

  def get_subject_by_days(data = nil)
    return if data.nil?

    on = ["T2", "T3", "T4", "T5", "T6", "T7"]

    # data = [{ :name_or_code, :on => , :time => range .. }]

    result = Array.new

    on.each do |on|
      days = Array.new

      #Get subject by day
      data.select{|x| x[:on].eql? on}.each do |sbj|
        days << sbj
      end

      result << days
    end
    # List all subject times by day
    return result
  end

  def delete_by_subject_name(sbj, data = nil)
    arr = Array.new
    data.each do |e|
      arr << e.delete_if {|a| a[:name] == sbj}
    end
  end

  def get_index_by_subject(data = nil, sbj_name)
    indexs = Array.new

    data.each_with_index do |e, i|
      e.each_with_index do |s, j|
        if s[:name] == sbj_name
          indexs << [i, j]
        end
      end
    end

    return indexs
  end

  def get_schedule
    raw_data = @raw_data
    i_sbj = @i_sbj
    i_time = @i_time

    # return if data.nil?
    list = []
    data = ""

    begin
      data = get_subject_by_days(parse_data_for_hcmus(raw_data))
    rescue
      return "Error when processing data"
    end

    i_sbj = 0 if i_sbj.nil?

    lst_subject = data.flatten.map { |e| e[:name]}.uniq
    lst_index_sbj = get_index_by_subject(data, lst_subject[i_sbj])

    return "END_OF_RESULT" if i_sbj > lst_subject.count

    i_time = lst_index_sbj[0] if i_time.nil?
    curr_sbj = data[i_time[0]][i_time[1]]
    data = delete_by_subject_name(curr_sbj[:name], data)

    # Each days
    data.each do |v|
      next if (v.empty?) || (v.length == 0)

      result = []
      clone = v

      sbj = v[rand(v.count)]

      if(sbj[:on].eql? curr_sbj[:on])
        sbj = curr_sbj
      else
        # Only one selection for this day
        if clone.length == 1
            list << sbj
            data = delete_by_subject_name(sbj[:name], data)
            next
        end
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

          if !any_overlapping_ranges([sbj[:time], next_sbj[:time]])
              result << sbj
              result << next_sbj
              break
          end
      end

      # No result for combine subject
      if result.empty?
          # Get one
          if(sbj[:on].eql? curr_sbj[:on])
            sbj = curr_sbj
          else
            sbj = v[rand(v.count)]
          end

          result << sbj
          data = delete_by_subject_name(sbj[:name], data)
      else
          result.each do |e|
            data = delete_by_subject_name(e[:name], data)
          end
      end

      list << result
    end

    next_i_for_time = lst_index_sbj.find_index(i_time) + 1

    if next_i_for_time >= lst_index_sbj.count
      i_sbj = sbj + 1
      i_time = []
    else
      i_time = lst_index_sbj[next_i_for_time]
    end

    #Re-format list
    list.each do |t|
      t.each do |e|
        e[:time] = e[:on] <<"(" << e[:time].begin.to_s << "-" <<
        e[:time].end.to_s << ")"

        e.delete(:on)
        e.delete(:room)
      end
    end

    return [list, i_sbj, i_time, raw_data]
  end
end