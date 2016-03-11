json.array!(@calendars) do |calendar|
  json.extract! calendar, :id, :res_date, :reserved
  json.url calendar_url(calendar, format: :json)
end
