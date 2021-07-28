module Campa
  module Core
    class Load
      def initialize
        @evaler = Evaler.new
      end

      def call(*paths, env:)
        verify_presence(paths)
        paths.reduce(nil) do |_, file|
          reader = Reader.new(File.expand_path(file))
          evaler.eval(reader, env)
        end
      end

      private

      attr_reader :evaler

      def verify_presence(paths)
        not_here = paths.find { |f| !File.file?(File.expand_path(f)) }
        raise Error::NotFound, not_here if !not_here.nil?
      end
    end
  end
end
