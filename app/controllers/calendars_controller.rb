class CalendarsController < ApplicationController
	require 'open-uri'
	require 'json'
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

	# Openweather json file url
	@@source = "http://api.openweathermap.org/data/2.5/forecast/city?id=3196359&APPID=cf3d48ecd470b5f8204d8e6c4dece1f6"

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
    #@customers = Customer.all
    @current_date = DateTime.now
    @calendar_date = @current_date

    # Get next months calendar registrations
    if params[:date]
			@calendar_date = DateTime.parse(params[:date])
			#binding.pry
			#@calendar_date_query = @calendar_date.strftime("%Y-%m")
			@calendars = @calendars.where("extract(year from res_date) = ?", @calendar_date.year)
			@calendars = @calendars.where("extract(month from res_date) = ?", @calendar_date.month)
    end

    # Get openweather api json file
		@weather = JSON.parse(open(@@source).read)

		#binding.pry
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.reserved = true
    @calendar.customer_id = current_customer.id

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to action: "index", notice: 'Calendar was successfully created.' }
        format.json { render :show, status: :created, location: @calendar }
      else
        format.html { render :new }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
		binding.pry
		@calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	# Daily schedule controller
	def schedule
		@calendars = Calendar.all
		@weather = JSON.parse(open(@@source).read)

		if params[:date]
			# Get the date of the day of the registration
			@page_date = params[:date]
			@day_start = DateTime.parse(@page_date + " 08:00")
			@day_end = DateTime.parse(@page_date + " 20:00")

			# Get daily res_date schedule
			# Query for sqlite
			#@calendars = @calendars.where("strftime('%Y-%m-%d', res_date) = ?", @date)
			# Query for pg
			@calendars = @calendars.where("res_date >= ?", @day_start)
			@calendars = @calendars.where("res_date < ?", @day_end)
			@daily_schedule = []

			#24 hour schedule
			(8..20).each do |hour|
				next unless (hour % 2) == 0

				@hour = hour.to_s

				if @hour.length == 1
					@hour = "0" + @hour
				else
					@hour
				end

				# Check if the hour can be reserved
				@res_hour = DateTime.parse(@page_date + " " + @hour)
				@reservable = @calendars.where("res_date = ?", @res_hour).empty?

				#if @reservable == true
				#	@reservation_details = params[:date] + " " + @hour
				#end

				@can_unreserve = false
				# add unreserve button when reservable is false
				# need to check if the current_customer has the id
				if @reservable == false &&
 					 @calendars.where("res_date = ?", @res_hour)[0][:customer_id] == current_customer.id
					@can_unreserve = true
					@unreserve_id = @calendars.where(res_date: @res_hour)[0].id
				end

				@daily_schedule << {time: @hour + ":00",
														reservable: @reservable,
														reservation_details: @res_hour,
														unreservable: @can_unreserve,
														unreserve_id: @unreserve_id}
				#binding.pry
			end
		end
		#binding.pry
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:res_date, :reserved)
    end

end
