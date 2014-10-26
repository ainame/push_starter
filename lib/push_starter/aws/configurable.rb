# -*- coding: utf-8 -*-
module PushStarter
  module AWS
    module Configurable
      def client
        self.class.client
      end

      def self.included(base)
        base.class_eval do
          class << self
            # cache client object unti re-configuring
            def client
              @client ||= service_class.new(configuration.to_h)
            end

            def configure(&block)
              # remove client cache at first
              clear_client_cache!
              aws_options = Options.new(::AWS::Core::Configuration.accepted_options)
              options = Options.new(@service_options)
              yield aws_options, options
              @aws_core_configuration = ::AWS::Core::Configuration.new(aws_options.to_h)
              set_service_options(options)
            end

            def configuration
              stub_configuration || @aws_core_configuration
            end

            def stub_configuration
              #
            end

            def service_options(*args)
              @service_options = Set.new(args)
              (class << self; self; end).instance_eval do
                attr_accessor(*args)
              end
            end

            def set_service_options(options)
              options.to_h.each do |key, value|
                send("#{key}=", value)
              end
            end

            def clear_client_cache!
              @client = nil
            end

            protected
            def service_class
              matched = self.to_s.match(/\APushStarter\:\:([a-zA-Z_\:]+)/).captures[0]
              (matched + '::Client').constantize
            end
          end
        end
      end

      class Options < BasicObject
        def initialize(accepted_options)
          @accepted_options = accepted_options
          @config = {}
        end

        def to_h
          @config
        end

        def method_missing(method, *args)
          return super unless setter?(method.to_s)

          name = extract_name(method.to_s)
          return super unless accept?(name)

          @config[name] = args[0]
        end

        def setter?(method)
          method =~ /\A\w*=\z/
        end

        def extract_name(method)
          method.match(/\A(\w*)=\z/).captures[0].to_sym
        end

        def accept?(name)
          @accepted_options.include?(name)
        end
      end
    end
  end
end
