module Campa
  module Core
    # Implements a <i>Campa</i> function
    # that reads ({Reader}) and evaluates ({Evaler})
    # files with valid <i>Campa</i> code in the given {Context}.
    class Load
      def initialize
        @evaler = Evaler.new
      end

      # @param paths [Array<String>] Strings representing paths to files
      #   to be evaled in a given context
      # @param env [Context] where the files pointed by <i>paths</i>
      #   will be evaled
      # @return [Object] value of the last form evaled from the last file
      #   given by <i>paths</i>
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
