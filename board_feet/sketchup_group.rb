module Sketchup
  class Group
    def stock_size=(stock_size)
      @stock_size=stock_size
    end

    def stock_size()
      @stock_size
    end

    def board_feet()
      ((self.bounds.width.to_f * self.bounds.height.to_f * self.bounds.depth.to_f) / 144).round(2)
    end

    def longest_side()
      [self.bounds.width.to_f, self.bounds.height.to_f, self.bounds.depth.to_f].max
    end
    
    def decimal_bounds()
      {
        :width => self.bounds.width.to_f.round(2),
        :height => self.bounds.height.to_f.round(2),
        :depth => self.bounds.depth.to_f.round(2)
      }
    end
  end
end
