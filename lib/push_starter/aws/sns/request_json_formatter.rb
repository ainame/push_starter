module PushStarter
  module AWS
    class SNS
      class RequestJSONFormatter
        DEFAULT_APNS_PUBLISH_TARGET = 'APNS'
        attr_reader :payloads

        def initialize(apns_target: DEFAULT_APNS_PUBLISH_TARGET)
          @apns_target = apns_target
        end

        def call(platform:, payload:)
          message = {}
          message[@apns_target] = payload if platform == 'APNS'
          message['GCM'] = payload if platform == 'GCM'
          message.to_json
        end
      end
    end
  end
end
