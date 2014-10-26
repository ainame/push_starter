module PushStarter
  class Subscriber
    attr_reader :topic, :user

    def initialize(user)
      @user = user
    end

    def endpoints
      @endpoints ||= find_endpoints
    end

    def find_endpoints
      raise 'override me'
    end

    def accept?(event)
      raise 'override me'
    end

    def subscribe(topic)
      raise 'override me'
    end

    def unsubscribe(topic)
      raise 'override me'
    end
  end
end
