class CalendarsController < ApplicationController
	require 'open-uri'
	require 'json'
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
    @customers = Customer.all
    
    @source = "http://api.openweathermap.org/data/2.5/forecast/city?id=3196359&APPID=cf3d48ecd470b5f8204d8e6c4dece1f6"
		@weather = JSON.parse(open(@source).read)
		
		# Need a helper to go with this
		#		<%= #"Weather:"  + @weather["list"][0]["dt_txt"] %><br>
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
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def logout_customer
    @notice = "foo"
    sign_out_and_redirect("/")
  end

	# Daily schedule controller
	def schedule
		@calendars = Calendar.all
  
		if params[:date]
			@date = DateTime.parse(params[:date]).strftime("%Y-%m-%d")
			# Query for sqlite for postgres use extract method
			@calendars = @calendars.where("strftime('%Y-%m-%d', res_date) = ?", @date)
			
			@daily_schedule = []
			
			#24 hour schedule
			(0..23).each do |hour|
				@hour = hour.to_s
				
				if @hour.length == 1  
					@hour = "0" + @hour
				else
					@hour 
				end
				
				@reservable = @calendars.where("strftime('%H', res_date) = ?", @hour).empty?
				
				if @reservable == true
					@reservation_details = params[:date] + " " + @hour
				end
				
				@daily_schedule << {time: @hour + ":00",
														reservable: @reservable,
														reservation_details: DateTime.parse(@reservation_details)}
			end
		end
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
