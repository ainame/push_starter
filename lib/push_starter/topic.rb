module PushStarter
  class Topic
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def post_event(poster, event)
      notify_subscribers(poster, event)
    end

    def subscribers
      @subscribers ||= find_subscribers
    end

    def find_subscribers
      raise 'orverride me'
    end

    def notify_subscribers(poster, event)
      subscribers.each do |subscriber|
        next if !event.publish_to_self? && poster.id == subscriber.user.id
        PushStarter::Publisher.new(self).publish(event, subscriber)
      end
    end
  end
end
