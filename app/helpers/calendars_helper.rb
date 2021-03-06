# Calendar view helper
module CalendarsHelper
	@@daily_weather_iterator = 0
	@@daily_weather_schedule = Hash.new

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
			"Unavailable"
		# Check daily iterator
		elsif @weather["list"][@@daily_weather_iterator]["dt_txt"][0..9] == day.strftime("%Y-%m-%d")
			#binding.pry
			# Get todays current weather
			if @@daily_weather_iterator == 0
				#return variable for view
				report = @weather["list"][@@daily_weather_iterator]
				
				@@daily_weather_schedule[day.strftime("%Y-%m-%d")] = report
				#set iterator for next day midday
				@@daily_weather_iterator = (24 - @weather["list"][@@daily_weather_iterator]["dt_txt"][11..12].to_i)/3 + 4
				#binding.pry
				report["weather"][0]["main"]
			else
				# return variable for view
				report = @weather["list"][@@daily_weather_iterator]

				@@daily_weather_schedule[day.strftime("%Y-%m-%d")] = @weather["list"][@@daily_weather_iterator-4]
				#iterate to next day
				@@daily_weather_iterator += 8
				report["weather"][0]["main"]
			end
		# Cornercase return
		else
			"Unavailable"
		end
	end

	# For daily reports
	def schedule_weather
	end

	# No previous path for current month
  def is_current_month?
		@current_date.strftime("%Y-%m") == @calendar_date.strftime("%Y-%m")
  end
end
