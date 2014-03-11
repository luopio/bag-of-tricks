#coding=utf-8
require 'google/api_client'

class YoutubeAPI

  def initialize
    # Initialize the client.
    @client = Google::APIClient.new(application_name: 'Some-App',
                                    application_version: '0.1',
                                    authorization: nil,
                                    key: 'xxxxxxx')
    @youtube = @client.discovered_api 'youtube', 'v3'
  end

  def get_users_channels
    channels_response = @client.execute!(
        :api_method => @youtube.channels.list,
        :parameters => {
            part: 'id',
            forUsername: 'usernameXXX',
        }
    )
    channels_response.data.items
  end

  def get_all_content_from_channel channel_id
    response = @client.execute!(
        :api_method => @youtube.search.list,
        :parameters => {
            part: 'id, snippet',
            channelId: channel_id,
            maxResults: 50
        }
    )
    response.data.items
  end

  def get_all_videos channel_id=nil
    channel_id ||= get_users_channels.first.id
    puts "looking from channel #{channel_id}.."
    videos = []
    get_all_content_from_channel(channel_id).each do |content|
      case content.id.kind
        when 'youtube#video'
          videos << content
          puts "+ found video #{videos.length}"
        when 'youtube#channel'
          if channel_id != content.id.channelId
            puts ">> dive into channel #{content.id.channelId}"
            videos.concat( get_all_videos(content.id.channelId) )
          end
      end
    end
    videos
  end

  def get_video_data video_ids
    response = @client.execute!(
        :api_method => @youtube.videos.list,
        :parameters => {
            part: 'snippet',
            id: video_ids.join(',')
        }
    )
    response.data.items
  end 

end

if $0 == __FILE__
  require 'pp'
  y = YoutubeAPI.new
  y.get_all_videos.each do |v|
    pp v
    puts "---------------------"
  end

  # continue here... one result from get content from channel is another channel, so need to make it recursive..

  #YoutubeAPI.new.get_all_videos.each do |v|
  #  pp v.snippet.thumbnails.medium.url
  #end
end