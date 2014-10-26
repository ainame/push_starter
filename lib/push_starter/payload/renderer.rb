# -*- coding: utf-8 -*-
module PushStarter
  class Payload
    class Renderer

      def initialize(endpoint)
        @endpoint = endpoint
      end

      def renderer
        if @endpoint.kind_of?(PushStarter::Endpoint::MobileDevice)
          case @endpoint.platform.upcase
          when 'APNS'
            PushStarter::Payload::Renderer::APNS.new
          when 'GCM'
            PushStarter::Payload::Renderer::GCM.new
          end
        end
      end

      def call(payload)
        renderer.call(payload)
      end

      class Base
        SHORTEN_MESSAGE_SUFFIX = "…".freeze

        def self.call(payload)
          new.call(payload)
        end

        def call(_payload)
          payload = _payload.dup
          render_with_adujst_payload_size(payload)
        end

        protected
        def render(payload)
          raise 'orverride me'
        end

        def render_with_adujst_payload_size(payload)
          rendered_payload = render(payload)
          if rendered_payload.bytesize > max_payload_bytesize
            payload.alert = slice_alert(rendered_payload, payload.alert.dup)
            render(payload)
          else
            rendered_payload
          end
        end

        def slice_alert(payload, alert)
          diff_size = (payload.bytesize + SHORTEN_MESSAGE_SUFFIX.bytesize) - max_payload_bytesize
          alert.byteslice(0, alert.bytesize - diff_size).scrub('') + SHORTEN_MESSAGE_SUFFIX
        end
      end

      class APNS < Base
        MAX_APNS_PAYLOAD_BYTE_SIZE = 2048.freeze

        def max_payload_bytesize
          MAX_APNS_PAYLOAD_BYTE_SIZE
        end

        def render(payload)
          aps = { "content-available" => 1 }
          # when alert value is empty, set empty string as hack
          # see: http://stackoverflow.com/questions/19239737/silent-push-notification-in-ios-7-does-not-work
          aps[:alert] = payload.alert || ''
          aps[:sound] = payload.sound || ''
          aps[:badge] = payload.badge unless payload.badge.blank?
          {
            aps: aps,
            id: payload.id,
            event: payload.event,
            data: payload.data,
          }.to_json
        end
      end

      class GCM < Base
        MAX_GCM_PAYLOAD_BYTE_SIZE = 4096.freeze

        def max_payload_bytesize
          MAX_GCM_PAYLOAD_BYTE_SIZE
        end

        def render(payload)
          data = {
            id: payload.id,
            title: payload.title,
            event: payload.event,
            data: payload.data
          }
          data[:alert] = payload.alert if payload.alert
          data[:badge] = payload.badge if payload.badge

          { data: data }.to_json
        end
      end
    end
  end
end
