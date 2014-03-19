require 'cgi/core'
require 'open-uri' # redef open()
require 'json'

class GoogleMapsAPI

  @key = 'xxxx'
  @language = 'en'

  def self.geocode(number, street, city, country)
    param = ["#{street} #{number}", city, country].join ', '
    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI::escape param}&sensor=false&language=#{@language}"
    puts "GEOCODE>>#{url}"
    open(url) do |res|
      JSON::parse(res.read)
    end
  end

  def self.reverse_geocode(lat, lng)
    # 40.714224,-73.961452
    param = [lat, lng].join(',')
    # &key=#{@key} <= TODO: key causes error.. leave out for now.. get ready for quota issues
    url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{param}&sensor=false&language=#{@language}&key=#{@key}&result_type=street_address"
    puts url
    open(url) do |res|
      JSON::parse(res.read)
    end
  end

  def self.sort_location_result(res)
    sorted_res = {}
    # first result should be the most trustworthy according to Google
    res['results'].first['address_components'].each do |c|
      c['types'].each do |ct|
        sorted_res[ct] = c['long_name']
      end
    end
    # look for the city name which can be in any of these
    ['locality', 'administrative_area_level_3'].each do |var_name|
      if sorted_res[var_name]
        sorted_res['city_name'] = sorted_res[var_name]
        break
      end
    end
    sorted_res['lat'] = res['results'].first['geometry']['location']['lat']
    sorted_res['lng'] = res['results'].first['geometry']['location']['lng']
    sorted_res
  end

end

# What google reverse geocoding returns for street_address
#[{"address_components"=>
#      [
#       {"long_name"=>"277", "short_name"=>"277", "types"=>["street_number"]},

#       {"long_name"=>"Bedford Avenue",
#        "short_name"=>"Bedford Ave",
#        "types"=>["route"]},

#       {"long_name"=>"Williamsburg",
#        "short_name"=>"Williamsburg",
#        "types"=>["neighborhood", "political"]},

#       {"long_name"=>"Brooklyn",
#        "short_name"=>"Brooklyn",
#        "types"=>["sublocality", "political"]},

#       {"long_name"=>"Kings",
#        "short_name"=>"Kings",
#        "types"=>["administrative_area_level_2", "political"]},

#       {"long_name"=>"New York",
#        "short_name"=>"NY",
#        "types"=>["administrative_area_level_1", "political"]},

#       {"long_name"=>"United States",
#        "short_name"=>"US",
#        "types"=>["country", "political"]},

#       {"long_name"=>"11211", "short_name"=>"11211", "types"=>["postal_code"]}],

#  "formatted_address"=>"277 Bedford Avenue, Brooklyn, NY 11211, USA",
#  "geometry"=>
#      {"location"=>{"lat"=>40.714232, "lng"=>-73.9612889},
#       "location_type"=>"ROOFTOP",
#       "viewport"=>
#           {"northeast"=>{"lat"=>40.7155809802915, "lng"=>-73.9599399197085},
#            "southwest"=>{"lat"=>40.7128830197085, "lng"=>-73.96263788029151}}},
#  "types"=>["street_address"]}],
#    "status"=>"OK"}
