class ApplicationController < ActionController::Base
  def any_overlapping_ranges(array_of_ranges)
    array_of_ranges.sort_by(&:first).each_cons(2).any?{|x,y|x.last>y.first}
  end

  def schedule_on_days(data = [])
    on = ["T2", "T3", "T4", "T5", "T6", "T7"]

    # data = [{ :name_or_code, :on => , :time => range .. }]

    schedule_on_days = []

    on.each do |on|
      sbj_on_day = []
      days = []

      #Get subject by day
      data.select{|x| x[:on].eql? on}.each do |sbj|
        sbj_on_day << sbj
      end
      sbj_on_day.combination(2).to_a.each_with_index do |value, index|
        days << value unless any_overlapping_ranges([value[0][:time], value[1][:time]])
      end
      schedule_on_days << days
    end
    # List all subject times by day
    schedule_on_days
  end

  def schedule(schedule_all_days = [], next_steps = [], current = 0)
    if schedule_all_days.blank?
      return "ERROR"
    end

    schedule = []
    lens = []

    # If the first request
    next_steps = [0, 0, 0, 0, 0, 0] if next_steps.blank?

    for index in 0..(next_steps.length - 1)
      lens << schedule_all_days[index].length
    end

    total = lens.inject{ |sum, e| sum *= e}.to_i

    if current > total
      return "MAX"
    else
      current = current + 1
    end

    days = []

    for index in 0..(next_steps.length - 1)
      days << schedule_all_days[index][next_steps[index]]
    end

    schedule << days

    for index in (next_steps.length - 1).downto(0)
      if next_steps[index] + 1 < lens[index] then
        next_steps[index] += 1;
        break;
      end
      next_steps[index] = 0;
    end

    return {:schedule_all_days => schedule_all_days, :schedule => schedule, :next_steps => next_steps, :current => current}
  end

  def parse_data_for_hcmus(data = [])
    result = Array.new

    data.split("\n").each do |line|
      next if line.blank? || line.empty?

      lines = line.split("\t")

      times = if(!lines[7].is_a? Numeric)
                lines[7].split(/[()]+/)
              else
                lines[8].split(/[()]+/)
              end

      sbj_info = Hash.new
      sbj_info[:code] = lines[0]
      sbj_info[:name] = lines[1]
      sbj_info[:on] = times[0]
      sbj_info[:time]= times[1].split("-").first.to_i..times[1].split("-").last.to_i

      result << sbj_info
    end

    return result
  end
end
