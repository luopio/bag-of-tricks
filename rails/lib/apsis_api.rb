require 'net/http'
require 'json'
require 'date'

class ApsisApi

  def initialize
    @all_subscribers = nil
  end

  # Create one subscription. Subscription_data follows Apsis format:
  # Password 	String 	The subscriber's password (optional)
  # Email 	String 	The subscriber's email address (required)
  # Name 	String 	The name of the subscriber (optional)
  # Format 	String 	The subscriber's desired format (optional)
  # CountryCode 	String 	The subscriber's country code (optional)
  # PhoneNumber 	String 	The subscriber's phone number (optional)
  # ExternalId 	String 	The subscriber's external ID (optional)
  # DemDataFields 	List
  #     <DemDataField> 	The subscriber's list of (optional) demographic data fields
  # see http://se.apidoc.anpdm.com/Browse/Method/SubscriberService/CreateSubscriber
  def create_subscription mailing_list_id, subscription_data
    fetch_body "subscribers/mailinglist/#{mailing_list_id}/create?updateIfExists=true", subscription_data
  end

  def get_all_subscribers_write_to_yaml
    unless @all_subscribers
      @all_subscribers = fetch_body 'subscribers/all',
                                    { "AllDemographics" => false,
                                      "FieldNames" => []}
    end
    d = DateTime.now()
    File.open("apsis-all-subscribers-#{d.day}-#{d.month}-#{d.year}.yaml", 'w') do |f|
      f.write(YAML.dump(@all_subscribers))
    end
  end

  def mailinglists
    fetch_body 'mailinglists/1/100'
  end

  def get_all_subscribers
    @all_subscribers = fetch_body 'subscribers/all',
                        { "AllDemographics" => false,
                          "FieldNames" => []}
  end

  protected

  # Does all the heavy lifting
  def fetch_body(command, body=nil)
    uri = make_uri command
    req = make_request uri, body
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request req
    end
    o = JSON.parse(res.body)
    puts "Apsis says: #{o}"
    if o.is_a? Hash and o['Result'] and o['Result'].is_a? Hash and o['Result']['PollURL']
      uri = URI(o['Result']['PollURL'])
      result = nil
      puts "haz polling url #{uri}"
      (1..10).each do |i|
        sleep i
        content = Net::HTTP.get(uri)
        j = JSON.parse(content)
        if j['StateName'] == 'Error'
          puts "Error occured: #{content}"
          break
        elsif j['StateName'] == 'Completed'
          uri = URI(j['DataUrl'])
          result = Net::HTTP.get(uri)
          result = JSON.parse(result)
          break
        end
      end
      return result
    else
      o
    end
  end

  def make_uri command
    URI("http://se.api.anpdm.com/v1/#{command}")
  end

  def make_request uri, body
    puts "create request out of #{uri}"
    if body
      puts "create post request with body #{body}"
      r = Net::HTTP::Post.new(uri.request_uri)
      r.body = JSON.generate(body)
      r['Content-Type'] = 'application/json'
    else
      r = Net::HTTP::Get.new(uri.request_uri)
    end
    r.basic_auth api_key, ''
    r['Accept'] = 'application/json'
    r
  end

  def api_key
    Rails.application.config.apsis_api_key
  end

end