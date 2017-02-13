require 'active_support/json'
module FakeSQS
  module Actions
    class LoadMessages

      def initialize(options = {})
        @server    = options.fetch(:server)
        @queues    = options.fetch(:queues)
        @responder = options.fetch(:responder)
      end

      def call(params)
        name = params.fetch("QueueName")
        queue = @queues.create(name, params)

        file_path = params.fetch("FilePath")

        file = File.open(file_path, "r")
        file.each do |line|
          message = ActiveSupport::JSON.decode(line)
          queue.send_message(message)
        end

        @responder.call :DumpMessages
      ensure
        file.close
      end

    end
  end
end
