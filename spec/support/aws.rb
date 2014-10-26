module PushStarter
  module AWS
    STUB_CONFIGURATION = ::AWS::Core::Configuration.new(
      access_key_id: 'ACCESS_KEY_ID',
      secret_access_key: 'SECRET_ACCESS_KEY',
      stub_requests: true
    )

    stub_services = ::PushStarter::AWS.constants.map {|const| ::PushStarter::AWS.const_get(const) }
    stub_services.each do |service|
      service.class_eval do
        def self.stub_configuration
          STUB_CONFIGURATION
        end
      end
    end

    PushStarter::AWS::SNS.configure do |aws, service|
      service.platform_application_arn_apns = 'arn:aws:sns:ap-northeast-1:123456:app/APNS/test'
      service.platform_application_arn_gcm  = 'arn:aws:sns:ap-northeast-1:123456:app/GCM/test'
    end
  end
end
