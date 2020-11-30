class Schedule
	def parse_data_for_hcmus(raw_data)
		return nil if raw_data.nil?
		begin
		  result = []
		  raw_data.split("\n").each do |line|
			next if line.empty?
			arr = line.split("\t")
			subject = Hash.new
			subject[:code] = arr[2]
			subject[:name] = arr[1]
			subject[:time] = arr[7].match(/.+?(?=-P)/)[0]
			result << subject
		end
		  result
		rescue
		  nil
		end
	end
	
	def save_subject_if_not_exists(list_subject)
		return nil if list_subject.nil?
		list_subject_id = []
		list_subject.each do |sbj|
			subject = Subject.find_by(code: sbj[:code], name: sbj[:name], time: sbj[:time])
			if subject.nil?
				subject = new(code: sbj[:code], name: sbj[:name], time: sbj[:time])
				subject.save
			end
			list_subject_id << subject.id
		end
		list_subject_id
	end

	def get_list_subject(list_subject_id)
		return nil if list_subject_id.nil?
    begin
      list_subject = Subject.find(list_subject_id)
    rescue
      nil
    end
	end

	def delete_subject_by_name(list_subject, value)
		list_subject.reject! { |s| s.name.eql? value }
	end

	def get_schedule(list_subject_id, excluded)
		return nil if list_subject_id.nil?
    list_subject = get_list_subject(list_subject_id)
    return nil if list_subject.nil?
    
		if not excluded.nil?
			excluded.each do |e|
				list_subject.reject! { |s| s.on.eql? e[:on] and s.range.overlaps?(e[:x].to_i..e[:y].to_i) }
			end
		end

		list = []
		on = ["T2", "T3", "T4", "T5", "T6", "T7"]
		on.each_with_index do |d, i|
			subject_by_day = list_subject.select{ |x| x.on.eql? d }
			if (subject_by_day.empty?) || (subject_by_day.nil?)
				next
			end

			sbj1 = subject_by_day[rand(subject_by_day.count)]
			list << sbj1

			list_subject = delete_subject_by_name(list_subject, sbj1.name)
			subject_by_day = delete_subject_by_name(subject_by_day, sbj1.name)
			if subject_by_day == 0
				next
			end

			while subject_by_day.length != 0
				i2 = rand(subject_by_day.count)
				sbj2 = subject_by_day[i2]
				if not (sbj1.range).overlaps?(sbj2.range)
					list_subject = delete_subject_by_name(list_subject, sbj2.name)
					list << sbj2
					break
				else
					subject_by_day = delete_subject_by_name(subject_by_day, sbj2.name)
				end
			end
		end
		list
	end
end