module CalendarsHelper
	@@daily_weather_iterator = 0
	
	#Gets previous months calendar
	def prev_month
		#Reset daily weather iterator for daily weather reports
		@@daily_weather_iterator = 0
		# Set to December of previous year if on the end of year in index
		if @calendar_date.month == 1
			DateTime.new(@calendar_date.year-1, 12)
		# Set to previous month
		else
			DateTime.new(@calendar_date.year, @calendar_date.month-1)
		end
	end
	
	#Gets next months calendar
	def next_month
		#reset daily weather iterator
		@@daily_weather_iterator = 0
		# Set to January next year if on the end of the year in index
		if @calendar_date.month == 12
			DateTime.new(@calendar_date.year+1, 1)
		# Set to next month if you choose the next page
		else
			DateTime.new(@calendar_date.year, @calendar_date.month+1)
		end
	end
	
	#Gets the daily weather
	def calendar_weather(day)
		@daily_weather = day.strftime("%Y-%m-%d")
		
		# Check if the daily weather exists
		if @weather["list"][@@daily_weather_iterator].nil?
			"Not Available"
		# Check daily iterator
		elsif @weather["list"][@@daily_weather_iterator]["dt_txt"][0..9] == day.strftime("%Y-%m-%d")
			
			# Get todays current weather
			if @@daily_weather_iterator == 0
				report = @weather["list"][@@daily_weather_iterator]
				
				#set iterator for next day midday
				@@daily_weather_iterator = (24 - @weather["list"][@@daily_weather_iterator]["dt_txt"][11..12].to_i)/3 + 4
				report["weather"][0]["main"].to_s
			else
				#binding.pry
				report = @weather["list"][@@daily_weather_iterator]["weather"][0]["main"].to_s
				#iterate to next day
				@@daily_weather_iterator += 8
				report
			end
		# Cornercase return
		else
			"Not Available"
		end
	end
	
	# For daily reports
	def schedule_weather
	end
end
