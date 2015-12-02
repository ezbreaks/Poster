class Post < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :content
  validates_presence_of :scheduled_at
  validates_length_of :content, maximum: 140, message: 'Less than 140 please'
  validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now
  after_create :schedule

  def schedule
    begin
      ScheduleJob.set(wait_until: scheduled_at).perform_later(self)
      self.update(state: 'scheduled')
    rescue Exception => e
      self.update(state: 'Scheduling error', error: e.message)
    end
  end

  def display
    begin
      unless state == 'cenceled'
        if facebook == true
          to_facebook
        end
        if twitter == true
          to_twitter
        end
      end
      self.update_attributes(state: 'Posted')
    rescue Exception => e
      self.update_attributes(state: 'Posting Error', error: e.message)
    end
  end

  def to_twitter
    client = Twitter::REST::Client.new do |config|
      config.access_token = self.user.twitter.oauth_token
      config.access_token_secret = self.user.twitter.secret
      config.consumer_key = ENV["TWITTER_KEY"]
      config.consumer_secret = ENV["TWITTER_SECRET"]
    end
    client.update(self.content)
  end

  def to_facebook
    graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
    graph.put_connections("me", "feed", message: self.content)
  end



end
