class ApplicationController < ActionController::Base
  def any_overlapping_ranges(array_of_ranges)
    array_of_ranges.sort_by(&:first).each_cons(2).any?{|x,y|x.last>y.first}
  end
    
  def schedule_on_days(data = [])
    on = ["T2", "T3", "T4", "T5", "T6", "T7"]
    
    # data = [{ :name_or_code, :on => , :time => range ..  }]
    
    days = []
    schedule_on_days = []
    
    on.each do |on|
      sbj_on_day = []
    
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
    
  def schedule(schedule_on_days = [])
    schedule = []
    length = []
    counter = [0, 0, 0, 0, 0, 0] # 6 Day
    
    counter.length.times {
      length << schedule_on_days.length()
    }
    
    total = length.inject{ |sum, e| sum *= e}
    
    (total).times{
      days = []
    
      for index in 0..(counter.length - 1)
      days << schedule_on_days[index][counter[index]]
      end
    
      schedule << days
    
      for index in (counter.length - 1).downto(0)
        if counter[index] + 1 < length[index] then
          counter[index] += 1;
          break;
        end
        counter[index] = 0;
      end
    }
    
    schedule
  end
end