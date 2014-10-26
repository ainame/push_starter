module PushStarter
  class Endpoint
    def initialize(endpoint)
      @endpoint = endpoint
      @sns_endpoint = PushStarter::AWS::SNS::Endpoint.new(
        endpoint_arn: endpoint.arn, platform: endpoint.platform,
      )
    end

    def publish(payload)
      @sns_endpoint.publish(payload)
    end

    def platform
      @endpoint.platform
    end

    def create_message(topic:, event:, subscriber:)
      payload = PushStarter::Payload::Factory.create(topic, subscriber, event)
      PushStarter::Payload::Renderer.new(self).call(payload)
    end

    def accept?(event)
      raise 'override me'
    end

    def success(topic:, event:, subscriber:)
      raise 'orverride me'
    end

    def failure(topic:, event:, subscriber:)
      raise 'orverride me'
    end
  end
end
