module Campa
  class ResolutionError < StandardError
    def new(label)
      super "Unable to resolve symbol: #{label} in this context"
    end
  end
end
