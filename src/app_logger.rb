require 'logger'

class AppLogger
  class << self
    def logdev
      @logdev || $stdout
    end

    def logdev=(device)
      @logdev = device
      @logger = create
    end

  private
    def create
      ::Logger.new(logdev)
    end

    def logger
      @logger ||= create
    end

    def method_missing(method, *args, &block)
      logger.public_send(method, *args, &block)
    end

    def respond_to_missing?(method, include_private = false)
      logger.respond_to?(method)
    end
  end
end
