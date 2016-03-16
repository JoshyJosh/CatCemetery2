module CalendarsHelper

	def prev_month
		if @calendar_date.month == 1
			DateTime.new(@calendar_date.year-1, 12)
		else
			DateTime.new(@calendar_date.year, @calendar_date.month-1)
		end
	end
	
	def next_month
		if @calendar_date.month == 12
			DateTime.new(@calendar_date.year+1, 1)
		else
			DateTime.new(@calendar_date.year, @calendar_date.month+1)
		end
	end
end
