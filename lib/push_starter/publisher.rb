module PushStarter
  class Publisher

    def initialize(topic)
      @topic = topic
    end

    def publish(event, subscriber)
      subscriber.endpoints.each do |endpoint|
        return unless endpoint.accept?(event)
        message = endpoint.create_message(topic: @topic, event: event, subscriber: subscriber)
        begin
          result = !!endpoint.publish(message)
        rescue => e
          PushStarter.logger.error("#{self.class}#publish catch error: #{e.message} - #{e.backtrace.join("\n")}")
        ensure
          on_published(result, event, subscriber, endpoint)
        end
      end
    end

    private
    def on_published(result, event, subscriber, endpoint)
      if result
        endpoint.success(topic: @topic, event: event, subscriber: subscriber)
      else
        endpoint.failure(topic: @topic, event: event, subscriber: subscriber)
      end
      logging_result(result, event, subscriber, endpoint)
    end

    def logging_result(result, event, subscriber, endpoint)
      log = "#{self.class}#publish result:#{result ? 'success' : 'failure'} for event:#{event.name} user_id:#{subscriber.user.id}, endpoint:#{endpoint}."
      PushStarter.logger.info(log)
    end

  end
end
