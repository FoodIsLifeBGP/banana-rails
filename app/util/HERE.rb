require 'net/http'
require 'json'
class HEREAPI

    def self.getTime( lat,lon,lat2, lon2, mode=car,rounding=2)
        case mode
            when 'public'
                link ='https://route.ls.hereapi.com/routing/7.2/calculateroute.json?apiKey=16lU5PcIP-Gc8OzaFRjc9h8x1g29ZdE9IQJKq9pYqCI&waypoint0=geo!'+lat.to_s+','+lon.to_s+'&waypoint1=geo!'+lat2.to_s+','+lon2.to_s+'&mode=fastest;publicTransport;traffic:disabled'
            when "bike"
                link ='https://route.ls.hereapi.com/routing/7.2/calculateroute.json?apiKey=16lU5PcIP-Gc8OzaFRjc9h8x1g29ZdE9IQJKq9pYqCI&waypoint0=geo!'+lat.to_s+','+lon.to_s+'&waypoint1=geo!'+lat2.to_s+','+lon2.to_s+'&mode=fastest;bicycle;traffic:disabled'
            else
                link ='https://route.ls.hereapi.com/routing/7.2/calculateroute.json?apiKey=16lU5PcIP-Gc8OzaFRjc9h8x1g29ZdE9IQJKq9pYqCI&waypoint0=geo!'+lat.to_s+','+lon.to_s+'&waypoint1=geo!'+lat2.to_s+','+lon2.to_s+'&mode=fastest;car;traffic:disabled'

        end
    
        uri = URI(link)
        res = Net::HTTP.get_response(uri)
        res_data = JSON.parse(res.body)
        time = res_data['response']['route'][0]['summary']['travelTime']/60.0 if res.is_a?(Net::HTTPSuccess)
        time = time.round(rounding)
  #  puts(time)
        return time

    end
end



#waypoint0=geo!52.5,13.4&waypoint1=geo!52.5,13.45
puts HEREAPI.getTime(52.5,13.4,52.5,13.45,'bike')
puts("complete")