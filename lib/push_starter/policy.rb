module PushStarter
  class Policy
    def accept?(event)
      raise 'override me'
    end
  end
end
