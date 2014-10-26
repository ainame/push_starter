require_relative 'payload/renderer'

module PushStarter
  class Payload
    attr_reader :id, :event, :title, :data, :badge, :sound
    attr_accessor :alert

    def initialize(event:, title:, alert:, data:, badge:, sound:)
      @id = generate_push_id
      @event, @title, @alert, @data, @badge, @sound = event, title, alert, data, badge, sound
    end

    private
    def generate_push_id
      SecureRandom.hex(10)
    end

    class Factory
      class << self
        def create(topic, subscriber, event)
          args = build_args(topic, subscriber, event)
          create_instance(args)
        end

        def build_args(topic, subscriber, event)
          args = {
            event: event.name,
            data:  event.data,
            alert: nil,
            badge: nil,
            sound: nil,
          }

          unless event.silent?
            args[:alert] = event.alert(subscriber)
            args[:badge] = badge_count
            args[:sound] = event.sound
          end

          args
        end

        def create_instance(args)
          PushStarter::Payload.new(args)
        end

        def badge_count
          raise 'override me'
        end
      end
    end
  end
end
