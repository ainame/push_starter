module PushStarter
  module AWS
    class SNS
      include Configurable

      service_options *[
        :apns_target, :platform_application_arn_apns, :platform_application_arn_gcm
      ]
    end
  end
end
