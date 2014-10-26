# -*- coding: utf-8 -*-
module PushStarter
  class Event
    attr_reader :source

    def initialize(source = nil)
      @source = source
    end

    def name
      raise 'override me'
    end

    def alert(subscriber)
      ''
    end

    def sound
      ''
    end

    def data
      {}
    end

    def silent?
      false
    end

    def publish_to_self?
      false
    end
  end
end
