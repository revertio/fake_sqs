require 'active_support/json'
module FakeSQS
  module Actions
    class DumpMessages

      def initialize(options = {})
        @server    = options.fetch(:server)
        @queues    = options.fetch(:queues)
        @responder = options.fetch(:responder)
      end

      def call(params)
        name = params.fetch("QueueName")
        queue = @queues.create(name, params)

        file_path = params.fetch("FilePath")

        file = File.open(file_path, "w")

        queue.messages.each do |message|
          file.puts ActiveSupport::JSON.encode(message.attributes)
        end

        @responder.call :DumpMessages
      ensure
        file.close
      end

    end
  end
end
