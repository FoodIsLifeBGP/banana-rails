require 'net/http'
require 'json'
class HEREAPI

    class PointLocation
        attr_reader :latitude, :longitude
        def initialize(latitude, longitude)
            @latitude = latitude
            @longitude = longitude
        end
    end

    module TravelMode
        BIKE = 'bicycle'
        CAR = 'car'
        PUBLIC_TRANSPORT = 'publicTransport'
        PEDESTRIAN = 'pedestrian'
    end

    def self.get_time(origin, destination, travel_mode=TravelMode::CAR, rounding=0)
        here_url = "https://route.ls.hereapi.com/routing/7.2/calculateroute.json?apiKey=%<here_key>s&waypoint0=geo!%<origin_lat>s"\
                    ",%<origin_long>s&waypoint1=geo!%<dest_lat>s,%<dest_long>s&representation=overview&mode=fastest;%<travel_mode>s;traffic:#{travel_mode == TravelMode::CAR ? 'enabled' : 'disabled'}"
                    .% origin_lat: origin.latitude, origin_long: origin.longitude, dest_lat: destination.latitude,
                    dest_long: destination.longitude, travel_mode: travel_mode, here_key: ENV["HERE_API_KEY"]
        uri = URI(here_url)
        res = Net::HTTP.get_response(uri)
        unless res.is_a? Net::HTTPSuccess
            return "Error: #{res.message}"
        end
        begin
            res_data = JSON.parse(res.body)
            time = res_data['response']['route'][0]['summary']['travelTime'] / 60.0
            time.round(rounding)
        rescue
            return "Error: could not parse JSON response"
        end
    end
end
