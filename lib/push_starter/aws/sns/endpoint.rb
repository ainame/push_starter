# -*- coding: utf-8 -*-
module PushStarter
  module AWS
    class SNS
      class Endpoint
        attr_reader :endpoint_arn, :platform, :device_token

        def initialize(endpoint_arn:, platform:, device_token: nil)
          @endpoint_arn, @platform, @device_token = endpoint_arn, platform, device_token
          raise ArgumentError.new("#{self.class}.new must receive endpoint_arn and platform") unless @endpoint_arn && @platform
        end

        def self.client
          PushStarter::AWS::SNS.client
        end

        def client
          self.class.client
        end

        def self.create(platform:, device_token:)
          response = client.create_platform_endpoint(
            platform_application_arn: get_platform_application_arn(platform),
            token: device_token
          )
          new(endpoint_arn: response[:endpoint_arn], platform: platform, device_token: device_token)
        end

        def update(device_token:, custom_user_data: "")
          @device_token = device_token
          response = client.set_endpoint_attributes(endpoint_arn: @endpoint_arn,
            attributes: { 'Enabled' => 'true', 'CustomUserData' => custom_user_data, 'Token' => device_token }
          )
          response.successful?
        end

        def publish(payload)
          message = formatter.call(platform: @platform, payload: payload)
          response = client.publish(target_arn: @endpoint_arn, message: message, message_structure: 'json')
          response.successful?
        end

        private
        def formatter
          PushStarter::AWS::SNS::RequestJSONFormatter.new(apns_target: PushStarter::AWS::SNS.apns_target)
        end

        def self.get_platform_application_arn(platform)
          case platform.upcase
          when 'APNS'
            PushStarter::AWS::SNS.platform_application_arn_apns
          when 'GCM'
            PushStarter::AWS::SNS.platform_application_arn_gcm
          else
            raise 'unknown platform error'
          end
        end
      end
    end
  end
end
