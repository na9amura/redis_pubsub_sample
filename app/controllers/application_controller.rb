class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def sub
    Thread.new do
      redis = Redis.new(url: 'redis://redis:6379')
      redis.subscribe('channel1', 'channel2') do |on|
        on.message do |channel, msg|
          data = JSON.parse(msg)
          puts "##{channel} - [#{data['user']}]: #{data['message']}"
        end
      end
    end
  end

  def pub
    channel = params[:channel]
    user = params[:user]
    message = params[:message]
    redis = Redis.new(url: 'redis://redis:6379')
    redis.publish channel, { user: user, message: message }.to_json
  end
end
