module CalendarsHelper
	@@daily_weather_iterator = 0
	
	def prev_month
		@@daily_weather_iterator = 0
		if @calendar_date.month == 1
			DateTime.new(@calendar_date.year-1, 12)
		else
			DateTime.new(@calendar_date.year, @calendar_date.month-1)
		end
	end
	
	def next_month
		@@daily_weather_iterator = 0
		if @calendar_date.month == 12
			DateTime.new(@calendar_date.year+1, 1)
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
