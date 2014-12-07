class Weathers

  attr_reader :lat, :lon, :weatherStatus

  def initialize(lat, lon)
      @lat = lat
      @lon = lon

      display_weather
  end

  def call_open_weather_api(url)
          json_response = HTTParty.get(url).body
          return JSON.parse( json_response )
  end

  def display_weather

    url = "http://api.openweathermap.org/data/2.5/weather?lat="+@lat+"&lon="+@lon+"&type=like&units=imperial"

    parsed_weather_result = call_open_weather_api(url)

    parsed_weather_result['weather'].each do |result|
        @description = result['description']
    end

    temp = parsed_weather_result['main']['temp']

    @weatherStatus = "It is currently #{temp} and #{@description} outside."

  end
end

get '/weather' do
  @lat = params[:lat]
  @lon = params[:lon]

  weather = Weathers.new(@lat, @lon)


  @weatherStatus = weather.weatherStatus

  erb :weather

end