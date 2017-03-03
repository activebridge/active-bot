# frozen_string_literal: true

module RangeRefinements
  refine Range do
    def every(step, &block)
      c_time = self.begin.to_datetime
      finish_time = self.end.to_datetime
      foo_compare = self.exclude_end? ? :< : :<=

      arr = []
      while c_time.send(foo_compare, finish_time) do
        arr << c_time
        c_time = c_time.advance(step)
      end

      return arr
    end
  end
end
